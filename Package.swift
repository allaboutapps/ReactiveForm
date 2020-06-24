// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "ReactiveForm",
    products: [
        .library(
            name: "ReactiveForm",
            targets: ["ReactiveForm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveCocoa/ReactiveCocoa", .upToNextMajor(from: "11.0.0")),
        .package(url: "https://github.com/allaboutapps/DataSource", .upToNextMajor(from: "8.0.0"))
    ],
    targets: [
        .target(
            name: "ReactiveForm",
            dependencies: ["ReactiveCocoa", "DataSource"])
    ]
)
