// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hwan-kit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "HwanKit",
            targets: ["HwanKit"]
        ),
        .library(
            name: "Design",
            targets: ["Design"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: Version(8, 4, 0)))
    ],
    targets: [
        .target(
            name: "HwanKit",
            dependencies: [
                .target(name: "Design")
            ]
        ),
        .target(
            name: "Design",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
        .testTarget(
            name: "HwanKitTests",
            dependencies: ["HwanKit"]
        ),
    ]
)
