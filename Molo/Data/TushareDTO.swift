import Foundation

struct TushareRow {
    let raw: [String: Any]

    func string(_ key: String) -> String? {
        raw[key] as? String
    }

    func double(_ key: String) -> Double? {
        if let v = raw[key] as? Double { return v }
        if let v = raw[key] as? Int { return Double(v) }
        if let v = raw[key] as? String { return Double(v) }
        return nil
    }
}

struct IncomeRow {
    let endDate: String?
    let revenue: Double?
    let operCost: Double?
    let netProfitAttrP: Double?

    init(from row: TushareRow) {
        self.endDate = row.string("end_date")
        self.revenue = row.double("revenue")
        self.operCost = row.double("oper_cost")
        self.netProfitAttrP = row.double("n_income_attr_p")
    }
}

struct CashflowRow {
    let endDate: String?
    let nCashflowAct: Double?

    init(from row: TushareRow) {
        self.endDate = row.string("end_date")
        self.nCashflowAct = row.double("n_cashflow_act")
    }
}

struct BalanceRow {
    let endDate: String?
    let equity: Double?

    init(from row: TushareRow) {
        self.endDate = row.string("end_date")
        self.equity = row.double("total_hldr_eqy_exc_min_int")
    }
}
