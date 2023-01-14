// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rainbow",
    products: [
        .library(name: "Rainbow",targets: ["Rainbow"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Rainbow",dependencies: [], path: "Sources"),
        .target(
            name: "RainbowPlayground",
            dependencies: ["Rainbow"],
            path: "Playground"
        ),
        .testTarget(name: "RainbowTests",dependencies: ["Rainbow"], path: "Tests"),
    ]
)
