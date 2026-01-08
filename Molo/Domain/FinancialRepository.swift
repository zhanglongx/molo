import Foundation

struct FinancialRepository {

    func fetchMetricPoints(
        client: TushareClient,
        token: String,
        tsCode: String,
        dimension: ReportDimension
    ) async throws -> [MetricPoint] {

        async let incomeRows = client.query(
            token: token,
            apiName: "income",
            params: ["ts_code": tsCode],
            fields: ["ts_code", "end_date", "revenue", "oper_cost", "n_income_attr_p"]
        )

        async let cashflowRows = client.query(
            token: token,
            apiName: "cashflow",
            params: ["ts_code": tsCode],
            fields: ["ts_code", "end_date", "n_cashflow_act"]
        )

        async let balanceRows = client.query(
            token: token,
            apiName: "balancesheet",
            params: ["ts_code": tsCode],
            fields: ["ts_code", "end_date", "total_hldr_eqy_exc_min_int"]
        )

        let (income, cashflow, balance) = try await (incomeRows, cashflowRows, balanceRows)

        let incomeMap = Dictionary(uniqueKeysWithValues: income.compactMap { row -> (String, IncomeRow)? in
            guard let endDate = row.string("end_date") else { return nil }
            return (endDate, IncomeRow(from: row))
        })

        let cashflowMap = Dictionary(uniqueKeysWithValues: cashflow.compactMap { row -> (String, CashflowRow)? in
            guard let endDate = row.string("end_date") else { return nil }
            return (endDate, CashflowRow(from: row))
        })

        let balanceMap = Dictionary(uniqueKeysWithValues: balance.compactMap { row -> (String, BalanceRow)? in
            guard let endDate = row.string("end_date") else { return nil }
            return (endDate, BalanceRow(from: row))
        })

        // Merge by end_date
        let endDates = Set(incomeMap.keys)
            .intersection(Set(cashflowMap.keys))
            .intersection(Set(balanceMap.keys))
            .filter { dimension.includes(endDate: $0) }
            .sorted()

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd"

        // Prepare equity series for average equity approximation
        let equitiesByDate: [(String, Double)] = endDates.compactMap { d in
            guard let eq = balanceMap[d]?.equity else { return nil }
            return (d, eq)
        }

        var equityPrev: Double? = nil
        var equityIndex = 0

        var points: [MetricPoint] = []
        points.reserveCapacity(endDates.count)

        for endDate in endDates {
            let date = formatter.date(from: endDate) ?? Date(timeIntervalSince1970: 0)

            let inc = incomeMap[endDate]
            let cf = cashflowMap[endDate]
            let bal = balanceMap[endDate]

            // Gross margin = (revenue - oper_cost) / revenue
            let grossMarginPercent: Double? = {
                guard let revenue = inc?.revenue, revenue != 0, let operCost = inc?.operCost else { return nil }
                return (revenue - operCost) / revenue * 100.0
            }()

            // OCF / net profit
            let ocfToNetProfit: Double? = {
                guard let ocf = cf?.nCashflowAct, let np = inc?.netProfitAttrP, np != 0 else { return nil }
                return ocf / np
            }()

            // ROE approximation: net profit / avg equity
            // NOTE: quarterly income in CN reports is often YTD; we keep it as an approximation.
            let roePercent: Double? = {
                guard let np = inc?.netProfitAttrP, let eq = bal?.equity, eq != 0 else { return nil }

                // Find previous equity (previous end_date within the filtered series)
                while equityIndex < equitiesByDate.count && equitiesByDate[equityIndex].0 != endDate {
                    equityIndex += 1
                }
                if equityIndex > 0 {
                    equityPrev = equitiesByDate[equityIndex - 1].1
                }

                let avgEq = (equityPrev != nil) ? ((eq + (equityPrev ?? eq)) / 2.0) : eq
                guard avgEq != 0 else { return nil }
                return np / avgEq * 100.0
            }()

            points.append(MetricPoint(
                endDate: endDate,
                date: date,
                roePercent: roePercent,
                ocfToNetProfit: ocfToNetProfit,
                grossMarginPercent: grossMarginPercent
            ))
        }

        // Show latest on the right
        return points.sorted { $0.endDate < $1.endDate }
    }
}
