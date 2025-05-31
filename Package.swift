// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "apkg",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "apkg", targets: ["apkg"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "apkg",
            dependencies: []
        )
    ]
) 