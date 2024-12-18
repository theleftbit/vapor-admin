// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vapor-admin",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VaporAdmin",
            targets: ["VaporAdmin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: .init(4, 0, 0)),
        .package(url: "https://github.com/vapor/fluent.git", from: .init(4, 12, 0)),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: .init(2, 0, 0)),

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "VaporAdmin",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "Fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver")


            ]),
        .testTarget(
            name: "VaporAdminTests",
            dependencies: ["VaporAdmin"]
        ),
    ]
)
