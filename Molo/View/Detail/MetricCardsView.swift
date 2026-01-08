import SwiftUI
import Charts

struct MetricCardsView: View {
    let points: [MetricPoint]

    var body: some View {
        if points.isEmpty {
            ContentUnavailableView("暂无数据", systemImage: "chart.line.uptrend.xyaxis")
        } else {
            ScrollView {
                VStack(spacing: 12) {
                    metricCard(title: "ROE（估算）", subtitle: "净利润/平均股东权益", kind: .roe)
                    metricCard(title: "经营性现金流/净利润", subtitle: "n_cashflow_act / n_income_attr_p", kind: .ocfToNetProfit)
                    metricCard(title: "毛利率（估算）", subtitle: "(revenue - oper_cost) / revenue", kind: .grossMargin)
                }
            }
        }
    }

    private func metricCard(title: String, subtitle: String, kind: MetricKind) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Chart {
                ForEach(points) { p in
                    if let y = value(for: kind, point: p) {
                        LineMark(
                            x: .value("Period", p.date),
                            y: .value("Value", y)
                        )
                        .interpolationMethod(.catmullRom)

                        PointMark(
                            x: .value("Period", p.date),
                            y: .value("Value", y)
                        )
                    }
                }
            }
            .frame(height: 180)
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 5))
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 5))
            }

            if let last = points.last, let v = value(for: kind, point: last) {
                Text("最新：\(formatted(kind: kind, v: v)) · \(last.endDate)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func value(for kind: MetricKind, point: MetricPoint) -> Double? {
        switch kind {
        case .roe:
            return point.roePercent
        case .ocfToNetProfit:
            return point.ocfToNetProfit
        case .grossMargin:
            return point.grossMarginPercent
        }
    }

    private func formatted(kind: MetricKind, v: Double) -> String {
        switch kind {
        case .roe, .grossMargin:
            return String(format: "%.2f%%", v)
        case .ocfToNetProfit:
            return String(format: "%.2f", v)
        }
    }
}
