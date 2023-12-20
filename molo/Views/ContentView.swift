
import SwiftUI

struct ContentView: View {
@Environment(StockModel.self) var model: StockModel

    @State private var isPresented = false

    @State private var selectedStock: Stock = EmptyStock()

    var body: some View {
        VStack {
            HStack{
                Text("Stocks")
                .font(.title)
                .padding()

                Spacer()

                #if os(iOS)
                menuOniOS
                #elseif os(macOS)
                menuOnmacOS 
                #endif
            }

            List {
                ForEach(model.stocks, id: \.symbol) { stock in
                    StockRowView(stock: stock)
                    .swipeActions() {
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

    #if os(iOS)
    private var menuOniOS: some View {
        Menu {
            Button(action: {
                selectedStock = EmptyStock() 
                isPresented = true
            }) {
                Label("添加股票", systemImage: "plus")
            }
            Button(action: {
                // Add your action here
            }) {
                Text("Add 2")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title)
        }
        .padding()
    }
    #endif

    #if os(macOS)
    private var menuOnmacOS: some View {
        Button(action: {}) {
            Image(systemName: "ellipsis.circle")
                .font(.title)
        }
        .contextMenu {
            Button(action: {
                selectedStock = EmptyStock()
                isPresented = true
            }) {
                Label("添加股票", systemImage: "plus")
            }
            Button(action: {
                // Add your action here
            }) {
                Text("Add 2")
            }
        }
    }
    #endif
}

#Preview {
    ContentView()
    .environment(StockModel())
}
