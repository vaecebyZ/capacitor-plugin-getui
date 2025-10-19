// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VaecebyzCapacitorGetui",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "VaecebyzCapacitorGetui",
            targets: ["GetuiPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "GetuiPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/GetuiPlugin"),
        .testTarget(
            name: "GetuiPluginTests",
            dependencies: ["GetuiPlugin"],
            path: "ios/Tests/GetuiPluginTests")
    ]
)