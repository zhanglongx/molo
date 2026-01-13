import Foundation
import SwiftUI
import Combine

@MainActor
final class AppEnvironment: ObservableObject {
    @Published var tokenStore: TokenStore
    @Published var tushare: TushareClient
    @Published var stockCatalog: StockCatalogService
    @Published var repository: FinancialRepository

    init() {
        self.tokenStore = KeychainTokenStore()
        self.tushare = TushareClient(baseURL: URL(string: "https://api.tushare.pro")!)
        self.stockCatalog = StockCatalogService()
        self.repository = FinancialRepository()
    }
}
