// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Lumberjack",
    platforms: [
        
        .iOS(.v15),
        .macOS(.v13)
    
    ],
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

    ]
)
