import Foundation

enum TushareError: Error, LocalizedError {
    case invalidResponse
    case apiError(code: Int, message: String)
    case missingData

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .apiError(let code, let message):
            return "TuShare API error (\(code)): \(message)"
        case .missingData:
            return "TuShare returned empty data."
        }
    }
}

final class TushareClient {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func query(
        token: String,
        apiName: String,
        params: [String: Any],
        fields: [String]
    ) async throws -> [TushareRow] {

        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "api_name": apiName,
            "token": token,
            "params": params,
            "fields": fields.joined(separator: ",")
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw TushareError.invalidResponse
        }

        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard
            let dict = json as? [String: Any],
            let code = dict["code"] as? Int,
            let msg = dict["msg"] as? String
        else {
            throw TushareError.invalidResponse
        }

        if code != 0 {
            throw TushareError.apiError(code: code, message: msg)
        }

        guard
            let dataObj = dict["data"] as? [String: Any],
            let fieldsArr = dataObj["fields"] as? [String],
            let items = dataObj["items"] as? [[Any]]
        else {
            return []
        }

        return items.map { item in
            var row: [String: Any] = [:]
            for (idx, key) in fieldsArr.enumerated() where idx < item.count {
                let v = item[idx]
                if v is NSNull { continue }
                row[key] = v
            }
            return TushareRow(raw: row)
        }
    }
}
