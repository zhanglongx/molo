
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

    private var cancellables = Set<AnyCancellable>()
    
    func apiUrl(of symbols: [Symbol]) -> URL {
        let u = "https://stock.xueqiu.com/v5/stock/realtime/quotec.json?symbol=" 
                      + symbols.joined(separator: ",")
        return URL(string: u)!
    }

    
    struct Response: Decodable {
        var data: [XueqiuData]
        var error_code: Int
        var error_description: String?
    }
    
    func fetchData(of symbols: [Symbol], completion: @escaping ([XueqiuData]) -> Void) {
        URLSession.shared.dataTaskPublisher(for: apiUrl(of: symbols))
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { response in
                // FIXME: error code handling
                completion(response.data)
            }).store(in: &cancellables)
    }
}
