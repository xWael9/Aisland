// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Aisland",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Aisland",
            targets: ["Aisland"])
    ],
    dependencies: [
        // Add your SPM dependencies here
        // Example: .package(url: "https://github.com/example/package.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Aisland",
            dependencies: []),
        .testTarget(
            name: "AislandTests",
            dependencies: ["Aisland"])
    ]
)
