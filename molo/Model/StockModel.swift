
import SwiftUI

struct Stock: Decodable {
    var symbol: Symbol
    var name: String
    var price: Double?
    var change: Double?

    var cost: Double?
}

@Observable
class StockModel {

    var stocks = load() ?? [
        Stock(symbol: "SH601231", name: "环旭电子"),
        Stock(symbol: "SH601288", name: "农业银行")
    ]

    private var dataSource: DataSource?

    init() {
        dataSource = DataSource(stocks.map { $0.symbol }) { data in
            for (i, stock) in self.stocks.enumerated() {
                if let d = data.first(where: { $0.symbol == stock.symbol }) {
                    self.stocks[i].price = Double(d.current)
                    self.stocks[i].change = Double(d.percent)
                }
            }
        }
    }
}