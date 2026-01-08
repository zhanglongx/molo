import Foundation

struct StockBasic: Identifiable, Hashable {
    let tsCode: String
    let symbol: String
    let name: String

    var id: String { tsCode }
}

@MainActor
final class StockCatalogService: ObservableObject {
    @Published private(set) var stocks: [StockBasic] = []
    @Published private(set) var isLoading: Bool = false

    func loadIfNeeded(client: TushareClient, token: String) async {
        if !stocks.isEmpty { return }
        await reload(client: client, token: token)
    }

    func reload(client: TushareClient, token: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let rows = try await client.query(
                token: token,
                apiName: "stock_basic",
                params: ["exchange": "", "list_status": "L"],
                fields: ["ts_code", "symbol", "name"]
            )
            self.stocks = rows.compactMap { r in
                guard
                    let ts = r.string("ts_code"),
                    let sym = r.string("symbol"),
                    let nm = r.string("name")
                else { return nil }
                return StockBasic(tsCode: ts, symbol: sym, name: nm)
            }
            .sorted { $0.symbol < $1.symbol }
        } catch {
            // Keep silent; UI can still allow manual code input.
        }
    }
}
