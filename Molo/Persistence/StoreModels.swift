import Foundation
import SwiftData

@Model
final class WatchlistItem {
    @Attribute(.unique) var tsCode: String
    var displayName: String
    var isRead: Bool
    var createdAt: Date

    init(tsCode: String, displayName: String, isRead: Bool = false, createdAt: Date = Date()) {
        self.tsCode = tsCode
        self.displayName = displayName
        self.isRead = isRead
        self.createdAt = createdAt
    }
}

@Model
final class CachedMetricPoint {
    var tsCode: String
    var dimensionRaw: String
    var endDate: String
    var roePercent: Double?
    var ocfToNetProfit: Double?
    var grossMarginPercent: Double?
    var updatedAt: Date

    init(
        tsCode: String,
        dimensionRaw: String,
        endDate: String,
        roePercent: Double?,
        ocfToNetProfit: Double?,
        grossMarginPercent: Double?,
        updatedAt: Date = Date()
    ) {
        self.tsCode = tsCode
        self.dimensionRaw = dimensionRaw
        self.endDate = endDate
        self.roePercent = roePercent
        self.ocfToNetProfit = ocfToNetProfit
        self.grossMarginPercent = grossMarginPercent
        self.updatedAt = updatedAt
    }
}
