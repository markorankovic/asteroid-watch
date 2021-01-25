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
    ],
    targets: [
        .target(
            name: "AsteroidWatchAPI",
            dependencies: []
        ),
        .testTarget(
            name: "AsteroidWatchAPITests",
            dependencies: ["AsteroidWatchAPI"],
            resources: [
              .process("Resources")
            ]
        )
    ]
)
