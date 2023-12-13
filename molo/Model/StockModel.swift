
import SwiftUI

struct Stock: Codable {
    var symbol: Symbol
    var name: String
    var price: Double?
    var change: Double?

    var cost: Double?
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

    func add(_ stock: Stock) {
        stocks.append(stock)

        saveUserCost()
    }

    func update(_ stock: Stock) {
        if let i = stocks.firstIndex(where: { $0.symbol == stock.symbol }) {
            stocks[i] = stock
        }

        saveUserCost()
    }

    func del(_ stock: Stock) {
        stocks.removeAll { $0.symbol == stock.symbol }

        saveUserCost()
    }
}