// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StudentVue",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "StudentVue",
            targets: ["StudentVue"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/drmohundro/SWXMLHash", from: "7.0.2"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.4")
    ],
    targets: [
        .target(
            name: "StudentVue",
            dependencies: [
                "SWXMLHash",
                "SwiftSoup"
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
