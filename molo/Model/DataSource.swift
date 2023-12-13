
import Foundation
import Combine

// SH601231
typealias Symbol = String

struct XueqiuData: Decodable {
    var symbol: Symbol
    var current: Float
    var percent: Float
}

class DataSource {

    static let shared = DataSource()

    private func apiUrl(_ symbols: [Symbol]) -> URL {
        let u = "https://stock.xueqiu.com/v5/stock/realtime/quotec.json?symbol=" 
                      + symbols.joined(separator: ",")
        return URL(string: u)!
    }
    
    // XXX: use with convertFromSnakeCase
    struct Response: Decodable {
        var data: [XueqiuData]
        var errorCode: Int
        var errorDescription: String?
    }
    
    func fetchData(with model: StockModel) {
        let u = apiUrl(model.symbols)

        URLSession.shared.dataTask(with: u) { data, _, _ in

            // FIXME: handle error
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                if let response = try? decoder.decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        for (i, stock) in model.stocks.enumerated() {
                            if let d = response.data.first(where: { $0.symbol == stock.symbol }) {
                                model.stocks[i].price = Double(d.current)
                                model.stocks[i].change = Double(d.percent)
                            }
                        }
                    }
                }
            }
        }.resume()
    }
}
