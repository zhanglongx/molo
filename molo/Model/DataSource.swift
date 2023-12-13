
import Foundation
import Combine

// SH601231
typealias Symbol = String

struct XueqiuData: Decodable {
    var symbol: Symbol
    var current: Float
    var percent: Float
}

@available(macOS 10.15, iOS 13.0, *)
class DataSource {

    private var model: StockModel

    private var timer: Timer?

    init(with model: StockModel, timerInterval: TimeInterval = 300.0) {
        self.model = model

        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            self?.fetchData()
        }

        // initial fetch
        self.fetchData()
    }

    private var apiUrl: URL {
        let symbols = model.stocks.map { $0.symbol }

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
    
    func fetchData() {
        URLSession.shared.dataTask(with: apiUrl) { data, _, _ in

            // FIXME: handle error
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                if let response = try? decoder.decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        for (i, stock) in self.model.stocks.enumerated() {
                            if let d = response.data.first(where: { $0.symbol == stock.symbol }) {
                                self.model.stocks[i].price = Double(d.current)
                                self.model.stocks[i].change = Double(d.percent)
                            }
                        }
                    }
                }
            }
        }.resume()
    }
}
