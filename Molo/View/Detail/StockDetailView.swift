import SwiftUI
import SwiftData

@MainActor
final class StockDetailViewModel: ObservableObject {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded(Date)
        case failed(String)
    }

    @Published var points: [MetricPoint] = []
    @Published var state: LoadState = .idle

    private let cache = CacheStore()
    private var task: Task<Void, Never>?

    func load(
        env: AppEnvironment,
        context: ModelContext,
        item: WatchlistItem,
        dimension: ReportDimension
    ) {
        task?.cancel()
        state = .loading

        // 1) Show cache immediately
        if let cached = try? cache.load(tsCode: item.tsCode, dimension: dimension, context: context),
           !cached.isEmpty {
            self.points = cached
        }

        // 2) Refresh from network
        task = Task {
            guard let token = env.tokenStore.readToken(), !token.isEmpty else {
                await MainActor.run { self.state = .failed("未配置 TuShare Token（设置里填写）") }
                return
            }

            do {
                let fresh = try await env.repository.fetchMetricPoints(
                    client: env.tushare,
                    token: token,
                    tsCode: item.tsCode,
                    dimension: dimension
                )
                try cache.upsert(tsCode: item.tsCode, dimension: dimension, points: fresh, context: context)
                await MainActor.run {
                    self.points = fresh
                    self.state = .loaded(Date())
                }
            } catch {
                await MainActor.run {
                    self.state = .failed(error.localizedDescription)
                }
            }
        }
    }
}

struct StockDetailView: View {
    @EnvironmentObject private var env: AppEnvironment
    @Environment(\.modelContext) private var modelContext

    let item: WatchlistItem
    @Binding var reportDimension: ReportDimension

    @StateObject private var vm = StockDetailViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            MetricCardsView(points: vm.points)

            Spacer(minLength: 0)
        }
        .padding()
        .navigationTitle(item.displayName)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear {
            vm.load(env: env, context: modelContext, item: item, dimension: reportDimension)
        }
        .onChange(of: reportDimension) { _, newValue in
            vm.load(env: env, context: modelContext, item: item, dimension: newValue)
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.tsCode)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                switch vm.state {
                case .loading:
                    Text("正在更新…")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                case .loaded(let date):
                    Text("已更新：\(date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                case .failed(let msg):
                    Text(msg)
                        .font(.footnote)
                        .foregroundStyle(.red)
                default:
                    EmptyView()
                }
            }

            Spacer()

            Button {
                vm.load(env: env, context: modelContext, item: item, dimension: reportDimension)
            } label: {
                Label("刷新", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
        }
    }
}
