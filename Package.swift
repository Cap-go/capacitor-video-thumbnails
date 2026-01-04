// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapgoCapacitorVideoThumbnails",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapgoCapacitorVideoThumbnails",
            targets: ["CapgoVideoThumbnailsPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "CapgoVideoThumbnailsPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CapgoVideoThumbnailsPlugin"),
        .testTarget(
            name: "CapgoVideoThumbnailsPluginTests",
            dependencies: ["CapgoVideoThumbnailsPlugin"],
            path: "ios/Tests/CapgoVideoThumbnailsPluginTests")
    ]
)
