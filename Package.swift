// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "hwan-kit",
    platforms: [
        .iOS(.v15), .macOS(.v13)
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
        .library(
            name: "APIClient",
            targets: ["APIClient"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: Version(8, 4, 0))),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: Version(5, 10, 0)))
    ],
    targets: [
        .target(
            name: "HwanKit",
            dependencies: [
                .target(name: "Design"),
                .target(name: "APIClient")
            ]
        ),
        .target(
            name: "Design",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher")
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "HwanKitTests",
            dependencies: ["HwanKit"]
        ),
    ]
)
