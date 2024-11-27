// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "vapor-admin",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "vapor-admin",
            targets: ["vapor-admin"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "vapor-admin"),
        .testTarget(
            name: "vapor-adminTests",
            dependencies: ["vapor-admin"]
        ),
    ]
)
