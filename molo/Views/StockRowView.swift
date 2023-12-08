import SwiftUI

struct StockRowView: View {
    var stock: Stock
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.symbol)
                    .font(.title)
                Text(stock.name)
                    .font(.subheadline)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(String(format: "%.2f", stock.price ?? 0.0 ))
                    .font(.title)
                Text(String(format: "%.2f", stock.change ?? 0.0))
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    StockRowView(stock: Stock(
        symbol: "SH601231", 
        name: "中信证券", 
        price: 23.45, 
        change: 0.12))
}
