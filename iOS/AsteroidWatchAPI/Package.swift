// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AsteroidWatchAPI",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AsteroidWatchAPI",
            targets: ["AsteroidWatchAPI"]),
    ],
    dependencies: [
        .package(url: "../GeometryAPI", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "AsteroidWatchAPI",
            dependencies: ["GeometryAPI"]
        ),
        .testTarget(
            name: "AsteroidWatchAPITests",
            dependencies: ["AsteroidWatchAPI", "GeometryAPI"],
            resources: [
              .process("Resources")
            ]
        )
    ]
)
