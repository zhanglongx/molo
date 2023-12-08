
import SwiftUI

struct Stock {
    var symbol: Symbol
    var name: String
    var price: Double?
    var change: Double?
}

@Observable
class StockModel {
    var stocks: [Stock] = [
        Stock(symbol: "SH601231", name: "中信证券"),
        Stock(symbol: "SH601288", name: "农业银行")
    ]
}