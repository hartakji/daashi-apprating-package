// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppRatingWidget",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .library(
            name: "AppRatingWidget",
            targets: ["AppRatingWidget"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hartakji/daashi-widget-foundation", from: "1.0.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.13.9")
    ],
    targets: [
        .target(
            name: "AppRatingWidget",
            dependencies: [
                .product(
                    name: "WidgetFoundation",
                    package: "daashi-widget-foundation"
                ),
                .product(
                    name: "SwiftSoup",
                    package: "SwiftSoup"
                )
            ],
            path: "Sources"
        )
    ]
)
