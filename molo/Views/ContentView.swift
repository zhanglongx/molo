
import SwiftUI

struct ContentView: View {
    @Environment(StockModel.self) var model: StockModel

    @State private var isPresented = false

    @State private var selectedStock: Stock = NewEmptyStock()

    @State private var isShowCost = false

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
                    selectedStock = NewEmptyStock()
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
                StockDetailView(stock: $selectedStock)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        let stock = model.stocks[offsets.first!]
        model.del(stock)
    }

    private func editButton(_ stock: Stock) -> some View {
        Group {
            Button() {
                model.del(stock)
            } label: {
                Image(systemName: "trash")
            }
            .tint(.red)

            Button() {
                selectedStock = stock
                isPresented = true
            } label: {
                Image(systemName: "pencil")
            }
            .tint(.blue)
        }
    }
}

#Preview {
    ContentView()
    .environment(StockModel())
}
