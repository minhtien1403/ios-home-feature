// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HomeFeature",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "HomeFeature", targets: ["HomeFeature"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/minhtien1403/ios-core-package",
            branch: "master"
        ),
        .package(
            url: "https://github.com/minhtien1403/ios-domain-package",
            branch: "master"
        ),
    ],
    targets: [
        .target(
            name: "HomeFeature",
            dependencies: [
                .product(name: "Domain", package: "ios-domain-package"),
                .product(name: "Core", package: "ios-core-package"),
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: ["HomeFeature"]
        )
    ]
)
