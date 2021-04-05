// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "NotesApp",
    platforms: [
         .macOS(.v10_15)
    ],
    products: [
        .library(name: "NotesApp", targets: ["App"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.4.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0-rc")
    ],
    targets: [
        .target(name: "App", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Leaf", package: "leaf"),
            .product(name: "JWT", package: "jwt"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")
        ]),
        .target(name: "Run", dependencies: ["App"]),
    ]
)
