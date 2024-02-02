// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HMSRoomKit",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HMSRoomKit",
            targets: ["HMSRoomKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/100mslive/100ms-roomkit-models-ios", from: "1.3.0"),
        .package(url: "https://github.com/100mslive/Popovers", from: "1.0.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HMSRoomKit",
            dependencies: [
                "Popovers",
                .product(name: "HMSRoomModels", package: "100ms-roomkit-models-ios"),
                .product(name: "HMSSDK", package: "100ms-roomkit-models-ios"),
                .product(name: "HMSAnalyticsSDK", package: "100ms-roomkit-models-ios"),
                .product(name: "HMSHLSPlayerSDK", package: "100ms-roomkit-models-ios"),
                .product(name: "HMSBroadcastExtensionSDK", package: "100ms-roomkit-models-ios"),
                .product(name: "WebRTC", package: "100ms-roomkit-models-ios"),
                .product(name: "Lottie", package: "lottie-spm")
                ],
            resources: [.process("audio-level-white.json")]
        ),
    ]
)
