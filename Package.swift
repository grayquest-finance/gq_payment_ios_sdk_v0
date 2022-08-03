// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GrayQuestiOSSDK",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GrayQuestiOSSDK",
            targets: ["GrayQuestiOSSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/razorpay/razorpay-pod.git", .exact("1.2.8"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GrayQuestiOSSDK",
            dependencies: ["Razorpay"]),
        .binaryTarget(name: "Razorpay", path: "Razorpay.xcframework.zip"),
        .testTarget(
            name: "GrayQuestiOSSDKTests",
            dependencies: ["GrayQuestiOSSDK"]),
    ]
)
