
import SwiftUI

struct Stock: Codable {
    var symbol: Symbol
    var name: String
    var price: Double?
    var change: Double?

    var cost: Double?
}

func NewEmptyStock() -> Stock {
    Stock(symbol: "", name: "", price: nil, change: nil, cost: nil)
}

func IsEmptyStock(_ stock: Stock) -> Bool {
    stock.symbol.isEmpty || stock.name.isEmpty
}

@Observable
class StockModel {
    // FIXME: race condition
    var stocks = [
        Stock(symbol: "SH601231", name: "环旭电子"),
        Stock(symbol: "SH601288", name: "农业银行")
    ]

    init() {
        loadUserCost()
    }

    private func loadUserCost() {
        if let data = UserDefaults.standard.data(forKey: "userCost") {
            if let userCost = try? JSONDecoder().decode([Stock].self, from: data) {
                stocks = userCost
            }
        }
    }

    private func saveUserCost() {
        if let data = try? JSONEncoder().encode(stocks) {
            UserDefaults.standard.set(data, forKey: "userCost")
        } else {
            print("saveUserCost failed")
        }
    }

    var symbols: [Symbol] {
        stocks.map { $0.symbol }
    }

    func add(by symbol: Symbol, name: String, cost: Double? = nil) {
        let stock = Stock(symbol: symbol, name: name, cost: cost)

        stocks.append(stock)

        saveUserCost()
    }

    func update(by symbol: Symbol, cost: Double?) {
        if let i = stocks.firstIndex(where: { $0.symbol == symbol }) {
            stocks[i].cost = cost
        } else {
            return
        }

        saveUserCost()
    }

    func del(by symbol: Symbol) {
        stocks.removeAll { $0.symbol == symbol }

        saveUserCost()
    }
}
