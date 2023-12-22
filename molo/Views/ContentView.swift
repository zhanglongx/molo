
import SwiftUI

struct ContentView: View {
    @Environment(StockModel.self) var model: StockModel

    @State private var isPresented = false

    @State private var isShowCost = false

    @State private var stockEditor = StockEditor()

    var body: some View {
        VStack {
            HStack{
                Text("Stocks")
                .font(.title)
                .padding()

                Spacer()

                Text("Cost")
                Toggle("", isOn: $isShowCost)
                .labelsHidden()

                Button {
                    stockEditor.NewEditor()
                    isPresented = true
                } label: {
                    Image(systemName: "plus")
                    .font(.title)
                }
                .padding()
            }

            List {
                ForEach(model.stocks, id: \.symbol) { stock in
                    StockRowView(stock: stock, isShowCost: isShowCost)
                    #if os(macOS)
                    .contextMenu() {
                        editButton(stock)
                    }
                    #else
                    .swipeActions() {
                        editButton(stock)
                    }
                    #endif
                }
                .onDelete(perform: delete)
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $isPresented) {
                StockDetailView(stockEditor: $stockEditor)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let stock = model.stocks[offsets.first!]
        model.del(symbol: stock.symbol)
    }

    private func editButton(_ stock: Stock) -> some View {
        Group {
            Button() {
                model.del(symbol: stock.symbol)
            } label: {
                Image(systemName: "trash")
            }
            #if os(iOS)
            .tint(.red)
            #endif

            Button() {
                stockEditor.ExistEditor(stock)
                isPresented = true
            } label: {
                Image(systemName: "pencil")
            }
            #if os(iOS)
            .tint(.blue)
            #endif
        }
    }
}

#Preview {
    ContentView()
    .environment(StockModel())
}
