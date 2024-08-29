// swift-tools-version: 5.10.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "SwiftGH",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .executable(
            name: "SwiftGH",
            targets: ["SwiftGH"]
        ),
        .library(
            name: "GitCLI",
            targets: ["GitCLI"]
        ),
    ],
    dependencies: [
        // .package(url: "https://github.com/apple/swift-testing.git", from: "0.11.0"),
        //.package(url: "https://github.com/swift-server/swift-backtrace.git", exact: "1.3.5"),
        .package(url: "https://github.com/apple/swift-log.git", exact: "1.6.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", exact: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftGH", 
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                //.product(name: "Backtrace", package: "swift-backtrace"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "GitCLI"),
            ]
        ),
        .target(
            name: "GitCLI",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
    ]
)

//if let iniPath = ProcessInfo.processInfo.environment["INIPATH"] {
//    print("INIPATH=\(iniPath)")
//}

