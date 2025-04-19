// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package.
import PackageDescription

let package = Package(
    name: "skip-ifrit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .tvOS(.v17), .watchOS(.v10), .macCatalyst(.v17)],
    products: [
        .library(name: "SkipIfrit", type: .dynamic, targets: ["SkipIfrit"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.4.8"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "SkipIfrit", dependencies: [
            .product(name: "SkipFoundation", package: "skip-foundation")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "SkipIfritTests", dependencies: [
            "SkipIfrit",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
