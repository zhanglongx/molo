
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

                Button(action: {
                    isPresented = true
                    selectedStock = EmptyStock()
                }) {
                    Image(systemName: "plus")
                    .font(.title)
                }
                .padding()
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
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $isPresented) {
                StockDetailView(stock: $selectedStock)
            }
        }
    }
}

#Preview {
    ContentView()
    .environment(StockModel())
}
