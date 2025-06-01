// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "apkg",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "apkg", targets: ["apkg"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "apkg",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            resources: [
                .process("Resources/en.lproj"),
                .process("Resources/ru.lproj")
            ]
        ),
        .testTarget(
            name: "apkgTests",
            dependencies: ["apkg"],
            path: "Tests"
        )
    ]
) 