
import SwiftUI
import Combine

struct StockFormView: View {
    @Environment(StockModel.self) var model: StockModel

    @Binding var stock: Stock

    @State private var inputCost: String = "0.00"

    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                // Lock the symbol field if the stock is not empty
                TextField("名称", text: $stock.name)
                .disabled(!IsEmptyStock(stock))
                TextField("代码", text: $stock.symbol)
                .disabled(!IsEmptyStock(stock))
            }

            Section(header: Text("成本")) {
                DecimalInputView(prompt: "成本", value: $stock.cost)
            }
        }
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var stock = Stock(symbol: "SH601231", name: "环旭电子", cost: 0.00) 

        StockDetailView(stock: $stock)
        .environment(StockModel())
    }
}
            