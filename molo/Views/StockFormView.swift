
import SwiftUI
import Combine

struct StockFormView: View {
    @Environment(StockModel.self) var model: StockModel

    @Binding var stock: Stock

    @State private var inputCost: String = "0.00"

    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                TextField("名称", text: $stock.name)
                TextField("代码", text: $stock.symbol)
            }

            Section(header: Text("成本")) {
                TextField("成本", text: $inputCost)
                .onAppear(
                    perform: {
                        inputCost = String(format: "%.2f", stock.cost ?? 0)
                    }
                )
                .onReceive(Just(inputCost)) { newValue in
                    if let cost = Double(newValue) {
                        stock.cost = cost
                    } else {
                        inputCost = "0.00"
                    }
                }
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
            