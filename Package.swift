// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Lumberjack",
    platforms: [.iOS(.v15)],
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
