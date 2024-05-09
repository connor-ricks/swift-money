// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-money",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Money", targets: ["Money"]),
    ],
    targets: [
        .target(name: "Money"),
        .testTarget(name: "MoneyTests", dependencies: ["Money"]),
    ]
)
