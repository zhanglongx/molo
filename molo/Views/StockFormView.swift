
import SwiftUI
import Combine

struct StockFormView: View {
    @Environment(StockModel.self) var model: StockModel

    @Binding var stockEditor: StockEditor

    var body: some View {
        Form {
            Section(header: Text("基本信息")) {
                // Lock the symbol field if the stock is not empty
                TextField("代码", text: $stockEditor.stock.symbol)
                .disabled(!stockEditor.isCreate)
                TextField("名称", text: $stockEditor.stock.name)
                .disabled(!stockEditor.isCreate)
            }

            Section(header: Text("成本")) {
                DecimalInputView(prompt: "成本", value: $stockEditor.stock.cost)
            }
        }
    }
}

struct StockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        @State var stockEditor = StockEditor()

        StockDetailView(stockEditor: $stockEditor)
        .environment(StockModel())
    }
}
            