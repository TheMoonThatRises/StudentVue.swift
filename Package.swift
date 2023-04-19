// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StudentVue",
    platforms: [
        .iOS(.v13),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "StudentVue",
            targets: ["StudentVue"])
    ],
    dependencies: [
        .package(url: "https://github.com/drmohundro/SWXMLHash", from: "7.0.1")
    ],
    targets: [
        .target(
            name: "StudentVue",
            dependencies: [
                "SWXMLHash"
            ])
    ],
    swiftLanguageVersions: [.v5]
)
