// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Lumberjack",
    platforms: [.iOS(.v14)],
    products: [

        .library(
            name: "Lumberjack",
            targets: ["Lumberjack"]
        )

    ],
    dependencies: [],
    targets: [

        .target(
            name: "Lumberjack",
            dependencies: [],
            path: "Sources/Lumberjack"
        )

    ],
    swiftLanguageVersions: [.v5]
)
