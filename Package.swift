// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "ReactiveForm",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "ReactiveForm",
            targets: ["ReactiveForm"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", .upToNextMajor(from: "12.0.0")),
        .package(url: "https://github.com/allaboutapps/DataSource", .upToNextMajor(from: "8.1.5")),
    ],
    targets: [
        .target(
            name: "ReactiveForm",
            dependencies: ["ReactiveCocoa", "DataSource"],
            path: "ReactiveForm/"
        ),
    ]
)
