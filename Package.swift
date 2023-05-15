// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "binary",
    products: [
        .library(
            name: "binary",
            targets: ["binary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "binary",
            dependencies: [
                .product(name: "NIOCore", package: "swift-nio")
            ]),
        .testTarget(
            name: "binaryTests",
            dependencies: ["binary"]),
    ]
)
