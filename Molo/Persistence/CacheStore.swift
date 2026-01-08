import Foundation
import SwiftData

struct CacheStore {

    func load(tsCode: String, dimension: ReportDimension, context: ModelContext) throws -> [MetricPoint] {
        let dim = dimension.rawValue
        let descriptor = FetchDescriptor<CachedMetricPoint>(
            predicate: #Predicate { $0.tsCode == tsCode && $0.dimensionRaw == dim },
            sortBy: [SortDescriptor(\.endDate, order: .forward)]
        )
        let cached = try context.fetch(descriptor)

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyyMMdd"

        return cached.map { c in
            MetricPoint(
                endDate: c.endDate,
                date: formatter.date(from: c.endDate) ?? Date(timeIntervalSince1970: 0),
                roePercent: c.roePercent,
                ocfToNetProfit: c.ocfToNetProfit,
                grossMarginPercent: c.grossMarginPercent
            )
        }
    }

    func upsert(tsCode: String, dimension: ReportDimension, points: [MetricPoint], context: ModelContext) throws {
        let dim = dimension.rawValue

        // Delete existing cache for simplicity
        let existing = try context.fetch(FetchDescriptor<CachedMetricPoint>(
            predicate: #Predicate { $0.tsCode == tsCode && $0.dimensionRaw == dim }
        ))
        existing.forEach { context.delete($0) }

        for p in points {
            context.insert(CachedMetricPoint(
                tsCode: tsCode,
                dimensionRaw: dim,
                endDate: p.endDate,
                roePercent: p.roePercent,
                ocfToNetProfit: p.ocfToNetProfit,
                grossMarginPercent: p.grossMarginPercent
            ))
        }
        try context.save()
    }
}
