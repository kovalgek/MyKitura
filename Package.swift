// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyKituraApp",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.8.0"),
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.9.0")
    ],
    targets: [
        .target(name: "MyKituraApp", dependencies: [ .target(name: "Application"), "Kitura", "HeliumLogger"]),
        .target(name: "Application", dependencies: [ "Kitura" ]),
        
        .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura" ])
    ]
)
