
import SwiftUI
import Combine

struct StockDetailView: View {
    @Environment(StockModel.self) var model: StockModel

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var stock: Stock

    @State private var inputCost: String = ""

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
                        let filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered != newValue {
                            inputCost = filtered
                            stock.cost = Double(inputCost)
                        }
                    }
            }

            Button(action: {
                model.add(stock)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("保存")
            }

            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("取消")
                .foregroundStyle(.red)
            }
        }
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var stock = Stock(symbol: "SH601231", name: "环旭电子", cost: 0) 

        StockDetailView(stock: $stock)
            .environment(StockModel())
    }
}
            