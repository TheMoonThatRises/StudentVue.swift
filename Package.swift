// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StudentVue",
    platforms: [
        .iOS(.v11),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "StudentVue",
            targets: ["StudentVue"])
    ],
    dependencies: [
        .package(url: "https://github.com/drmohundro/SWXMLHash", from: "7.0.1"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.6.0")
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
