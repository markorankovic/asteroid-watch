// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GeometryAPI",
    products: [
        .library(
            name: "GeometryAPI",
            targets: ["GeometryAPI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GeometryAPI",
            dependencies: []),
        .testTarget(
            name: "GeometryAPITests",
            dependencies: ["GeometryAPI"]),
    ]
)
