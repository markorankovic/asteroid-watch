// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SpeedComparison",
    products: [
        .library(
            name: "SpeedComparison",
            targets: ["SpeedComparison"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SpeedComparison",
            dependencies: []),
        .testTarget(
            name: "SpeedComparisonTests",
            dependencies: ["SpeedComparison"]),
    ]
)
