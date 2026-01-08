import Foundation
import SwiftUI

@MainActor
final class AppEnvironment: ObservableObject {
    let tokenStore: TokenStore
    let tushare: TushareClient
    let stockCatalog: StockCatalogService
    let repository: FinancialRepository

    init() {
        self.tokenStore = KeychainTokenStore()
        self.tushare = TushareClient(baseURL: URL(string: "https://api.tushare.pro")!)
        self.stockCatalog = StockCatalogService()
        self.repository = FinancialRepository()
    }
}
