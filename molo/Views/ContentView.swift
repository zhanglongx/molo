
import SwiftUI

struct ContentView: View {
    @Environment(StockModel.self) var model: StockModel

    @State private var isShowCost = false

    @State private var isPresented = false

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
                ForEach(sortedStocks, id: \.symbol) { stock in
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
        model.del(by: stock.symbol)
    }

    private func editButton(_ stock: Stock) -> some View {
        Group {
            Button() {
                model.del(by: stock.symbol)
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

    private var sortedStocks: [Stock] {
        if isShowCost {
            return model.stocks.sorted { 
                if let cost0 = $0.costPercent, let cost1 = $1.costPercent {
                    return cost0 > cost1
                } else {
                    return false
                }
            }
        } else {
            return model.stocks.sorted {
                if let change0 = $0.change, let change1 = $1.change {
                    return change0 > change1
                } else {
                    return false
                }
            }
        }
    }
}

#Preview {
    ContentView()
    .environment(StockModel())
}
