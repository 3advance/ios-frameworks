// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "AWS3A",
    products: [
        .library(
            name: "AWS3A",
            targets: ["AWS3A"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AWS3A",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "AWS3ATests",
            dependencies: ["AWS3A"],
            path: "Tests"
        )
    ]
)
