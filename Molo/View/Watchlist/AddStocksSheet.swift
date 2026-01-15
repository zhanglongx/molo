import SwiftUI
import SwiftData

struct AddStocksSheet: View {
    @EnvironmentObject private var env: AppEnvironment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    enum Mode: String, CaseIterable, Identifiable {
        case pick = "列表选择"
        case batch = "批量录入"
        var id: String { rawValue }
    }

    @State private var mode: Mode = .pick
    @State private var query: String = ""
    @State private var batchText: String = ""
    @State private var selected: StockBasic?

    @State private var tokenMissingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Picker("方式", selection: $mode) {
                    ForEach(Mode.allCases) { m in
                        Text(m.rawValue).tag(m)
                    }
                }
                .pickerStyle(.segmented)

                switch mode {
                case .pick:
                    Section("搜索") {
                        TextField("输入股票名称或代码", text: $query)

                        if env.stockCatalog.isLoading {
                            ProgressView()
                        } else {
                            let results = env.stockCatalog.stocks
                                .filter { query.isEmpty ? true :
                                    $0.name.localizedCaseInsensitiveContains(query) ||
                                    $0.symbol.localizedCaseInsensitiveContains(query) ||
                                    $0.tsCode.localizedCaseInsensitiveContains(query)
                                }
                                .prefix(60)

                            ForEach(Array(results)) { s in
                                Button {
                                    selected = s
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(s.name)
                                            Text("\(s.symbol) · \(s.tsCode)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        if selected == s {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.tint)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                case .batch:
                    Section("批量代码") {
                        TextEditor(text: $batchText)
                            .frame(minHeight: 200)
                        Text("支持逗号或换行分隔，例如：000001, 600000 或 000001.SZ")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("添加公司")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") { addNow() }
                        .disabled(mode == .pick ? (selected == nil) : batchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .task {
                guard let token = env.tokenStore.readToken(), !token.isEmpty else { return }
                await env.stockCatalog.loadIfNeeded(client: env.tushare, token: token)
            }
            .alert("需要先配置 TuShare Token", isPresented: $tokenMissingAlert) {
                Button("知道了", role: .cancel) { }
            } message: {
                Text("请在设置里填写 Token 后再使用列表拉取功能；你仍可用“批量录入/手动代码”添加。")
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func addNow() {
        switch mode {
        case .pick:
            guard let s = selected else { return }
            insert(tsCode: s.tsCode, name: s.name)
            dismiss()
        case .batch:
            let parts = CodeNormalizer.splitBatch(batchText)
            let nameByTsCode = Dictionary(uniqueKeysWithValues: env.stockCatalog.stocks.map { ($0.tsCode, $0.name) })
            var inserted = 0
            for p in parts {
                if let ts = CodeNormalizer.normalizeToTsCode(p) {
                    insert(tsCode: ts, name: nameByTsCode[ts] ?? ts)
                    inserted += 1
                }
            }
            if inserted == 0 {
                tokenMissingAlert = true
            } else {
                dismiss()
            }
        }
    }

    private func insert(tsCode: String, name: String) {
        // Prevent duplicates via unique attribute; fetch first to avoid noisy errors.
        let existing = (try? modelContext.fetch(FetchDescriptor<WatchlistItem>(
            predicate: #Predicate { $0.tsCode == tsCode }
        ))) ?? []
        if !existing.isEmpty { return }

        modelContext.insert(WatchlistItem(tsCode: tsCode, displayName: name))
        try? modelContext.save()
    }
}
