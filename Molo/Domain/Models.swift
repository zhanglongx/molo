import Foundation

enum ReportDimension: String, CaseIterable, Identifiable {
    case annual
    case quarterly

    var id: String { rawValue }

    func includes(endDate: String) -> Bool {
        // endDate is YYYYMMDD
        guard endDate.count == 8 else { return false }
        let suffix = String(endDate.suffix(4))
        switch self {
        case .annual:
            return suffix == "1231"
        case .quarterly:
            // Typical quarterly reports: Q1(0331), H1(0630), Q3(0930)
            return suffix == "0331" || suffix == "0630" || suffix == "0930"
        }
    }
}

struct MetricPoint: Identifiable, Hashable {
    let endDate: String
    let date: Date
    let roePercent: Double?
    let ocfToNetProfit: Double?
    let grossMarginPercent: Double?

    var id: String { endDate }
}

enum MetricKind: String, CaseIterable, Identifiable {
    case roe = "ROE"
    case ocfToNetProfit = "经营性现金流/净利润"
    case grossMargin = "毛利率"

    var id: String { rawValue }
}
