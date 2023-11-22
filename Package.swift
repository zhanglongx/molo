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
    dependencies: [],
    targets: [
        .target(
            name: "molo",
            dependencies: [],
            path: "molo",
            resources: [.process("Assets.xcassets"), .process("molo.entitlements")]),
        .testTarget(
            name: "moloTests",
            dependencies: ["molo"],
            path: "moloTests"),
    ]
)