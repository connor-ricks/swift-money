// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-money",
    platforms: [
        .iOS(.v15),
        .macOS(.v15),
        .macCatalyst(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "Money", targets: ["Money"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins.git", exact: "0.59.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", exact: "1.18.6"),
    ],
    targets: [
        .target(name: "Money"),
        .testTarget(name: "MoneyTests", dependencies: [
            "Money",
            .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
        ]),
    ]
)

for target in package.targets where target.type != .system {
    target.swiftSettings = target.swiftSettings ?? []
    target.swiftSettings?.append(contentsOf: [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
    ])

    target.plugins = target.plugins ?? []
    target.plugins?.append(
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
    )
}
