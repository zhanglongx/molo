
import SwiftUI

struct StockEditor {
    var isCreate = true

    var stock: Stock = NewEmptyStock()

    mutating func NewEditor() {
        stock = NewEmptyStock()
        isCreate = true
    }

    mutating func ExistEditor(_ stock: Stock) {
        self.stock = stock
        isCreate = false
    }
}
