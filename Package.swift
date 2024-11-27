// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "vapor-admin",
    platforms: [
        .macOS(.v15)
    ],

    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.3.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/queues.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.0.0"),
        // Mailgun
        .package(url: "https://github.com/vapor-community/mailgun.git",
                 from: "5.0.0")
    ],
    targets: [
        
        .testTarget(
            name: "VaporAdminTests",
            dependencies: [
                .target(name: "VaporAdmin"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        ),
    ],
    swiftLanguageModes: [.v5]
)

var swiftSettings: [SwiftSetting] {
    [    .enableUpcomingFeature("DisableOutwardActorInference"),
         .enableExperimentalFeature("StrictConcurrency"),
    ]
}
