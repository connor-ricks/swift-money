// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-money",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .macCatalyst(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "Money", targets: ["Money"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.3"),
    ],
    targets: [
        .target(name: "Money"),
        .testTarget(name: "MoneyTests", dependencies: ["Money"]),
    ]
)
