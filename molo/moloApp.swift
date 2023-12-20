
import SwiftUI
import Combine

let timeInterval = 300.0

@main
struct moloApp: App {
    @State private var model = StockModel()

    let timer = Timer.publish(every: timeInterval, on: .main, in: .common).autoconnect()

    init() {
        DataSource.shared.fetchData(model)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(model)
            .onReceive(timer) { _ in
                DataSource.shared.fetchData(model)
            }
        }
    }
}
