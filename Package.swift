// swift-tools-version:6.2
import PackageDescription

let concurrencySettings: [SwiftSetting] = [
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
]

let package = Package(
    name: "MoloApp",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        // Defines a library product for use by other packages or apps
        .library(
            name: "MoloApp",
            targets: ["MoloApp"]
        ),
    ],
    dependencies: [
        // Declare package dependencies here, for example:
        // .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
    ],
    targets: [
        // The main library target
        .target(
            name: "MoloApp",
            dependencies: [],
            path: "Molo",
            swiftSettings: concurrencySettings
        ),
    ]
)
