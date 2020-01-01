// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyKituraApp",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.8.0"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.9.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura-OpenAPI.git", from: "1.3.0"),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery.git", from: "3.0.1"),
        .package(url: "https://github.com/IBM-Swift/Swift-Kuery-PostgreSQL.git", from: "2.1.1"),
        .package(url: "https://github.com/IBM-Swift/Kitura-CredentialsHTTP.git", from: "2.1.3"),
    ],
    targets: [
        .target(name: "MyKituraApp", dependencies: [ .target(name: "Application"), "Kitura", "HeliumLogger", "KituraOpenAPI"]),
        .target(name: "Application", dependencies: [ "Kitura", "SwiftKuery", "SwiftKueryPostgreSQL", "CredentialsHTTP" ]),
        
        .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura" ])
    ]
)
