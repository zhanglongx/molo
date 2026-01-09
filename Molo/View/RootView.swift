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
            WatchlistView(selection: $selection, onAdd: { showAddSheet = true })
        } detail: {
            if let item = selection {
                StockDetailView(item: item, reportDimension: $reportDimension)
            } else {
                ContentUnavailableView("选择一家公司", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Picker("报表", selection: $reportDimension) {
                    Text("年报").tag(ReportDimension.annual)
                    Text("季报").tag(ReportDimension.quarterly)
                }
                .pickerStyle(.segmented)

                Button {
                    showAddSheet = true
                } label: {
                    Label("添加", systemImage: "plus")
                }

                #if os(iOS)
                Button {
                    showSettings = true
                } label: {
                    Label("设置", systemImage: "gear")
                }
                #endif
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
