import SwiftUI
import SwiftData

@main
struct MoloApp: App {
    private let container: ModelContainer = {
        let schema = Schema([
            WatchlistItem.self,
            CachedMetricPoint.self
        ])
        let config = ModelConfiguration(schema: schema,
                                                            isStoredInMemoryOnly: false,
                                                            cloudKitDatabase: .automatic
        )
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    @StateObject private var env = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(env)
                .modelContainer(container)
        }

        #if os(macOS)
        Settings {
            SettingsView()
                .environmentObject(env)
                .modelContainer(container)
        }
        #endif
    }
}
