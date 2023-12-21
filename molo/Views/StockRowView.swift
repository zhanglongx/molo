
import SwiftUI

struct StockRowView: View {
    var stock: Stock

    var isShowCost = false
    
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

                Text(String(format: "%@", showText))
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .background(showColor)
                .cornerRadius(5)
                .padding(.trailing)
            }
        }
    }

    var showText: String {
        let percent = isShowCost ? stock.costPercent : stock.change

        guard let p = percent else {
            return String("n/a")
        }

        let sign = p > 0 ? "+" : ""

        return String(format: "%@%.2f%%", sign, p)
    }

    var showColor: Color {
        let percent = isShowCost ? stock.costPercent : stock.change

        guard let p = percent else {
            return .gray
        }

        return p > 0 ? .red : p == 0 ? .gray : .green
    }
}

#Preview {
    StockRowView(stock: Stock(
        symbol: "SH601231", 
        name: "环旭电子", 
        price: 23.45, 
        change: -0.01))
}
