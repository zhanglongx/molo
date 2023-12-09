import SwiftUI

struct StockRowView: View {
    var stock: Stock
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stock.name)
                    .font(.title)
                    .bold()
                Text(stock.symbol)
                    .font(.subheadline)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(String(format: "%.2f", stock.price ?? 0.0))
                    .font(.title)
                    .bold()
                    .padding(.trailing)
                Text(String(format: "%@", change))
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .background(changColor)
                    .cornerRadius(5)
                    .padding(.trailing)
            }
        }
    }

    var change: String {
        guard let change = stock.change else {
            return ""
        }

        let sign = change > 0 ? "+" : ""

        return String(format: "%@%.2f%%", sign, change)
    }

    var changColor: Color {
        guard let change = stock.change else {
            return .gray
        }

        return change > 0 ? .red : change == 0 ? .gray : .green
    }
}

#Preview {
    StockRowView(stock: Stock(
        symbol: "SH601231", 
        name: "中信证券", 
        price: 23.45, 
        change: -0.01))
}
