// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "molo",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "molo",
            targets: ["molo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6")
    ],
    targets: [
        .target(
            name: "molo",
            dependencies: ["Yams"],
            path: "molo",
            resources: [.process("Assets.xcassets"), .process("molo.entitlements")]),
        .testTarget(
            name: "moloTests",
            dependencies: ["molo"],
            path: "moloTests"),
    ]
)