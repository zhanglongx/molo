import SwiftUI
import SwiftData

struct RootView: View {
    @EnvironmentObject private var env: AppEnvironment
    @Environment(\.modelContext) private var modelContext

    @State private var selection: WatchlistItem?
    @State private var reportDimension: ReportDimension = .annual
    @State private var showAddSheet = false
    @State private var showSettings = false

    var body: some View {
        NavigationSplitView {
            WatchlistView(selection: $selection,
                          onAdd: { showAddSheet = true },
                          onSettings: { showSettings = true }
            )
        } detail: {
            Group {
                if let item = selection {
                    StockDetailView(item: item, reportDimension: $reportDimension)
                } else {
                    ContentUnavailableView("选择一家公司", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("报表", selection: $reportDimension) {
                        Text("年报").tag(ReportDimension.annual)
                        Text("季报").tag(ReportDimension.quarterly)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 240)
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddStocksSheet()
                .environmentObject(env)
                .modelContext(modelContext)
        }
        #if os(iOS)
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingsView()
                    .environmentObject(env)
                    .navigationTitle("设置")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("完成") { showSettings = false }
                        }
                    }
            }
        }
        #endif
    }
}
