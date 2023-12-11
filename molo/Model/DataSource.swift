
import Foundation
import Combine

let timerInterval = 300.0

// SH601231
typealias Symbol = String

struct XueqiuData: Decodable {
    var symbol: Symbol
    var current: Float
    var percent: Float
}

@available(macOS 10.15, iOS 13.0, *)
class DataSource {

    private var symbols: [Symbol] = []

    private var timer: Timer?

    private var cancellables = Set<AnyCancellable>()

    private var completion: ([XueqiuData]) -> Void

    init(_ symbols: [Symbol], completion: @escaping ([XueqiuData]) -> Void) {
        self.symbols = symbols
        self.completion = completion

        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            self?.fetchData()
        }

        // initial fetch
        self.fetchData()
    }
    
    private var apiUrl: URL {
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
        URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let response = try? decoder.decode(Response.self, from: data) {
                    DispatchQueue.main.async {
                        self.completion(response.data)
                    }
                }
            }
        }.resume()
    }
}
