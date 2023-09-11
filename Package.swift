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
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/100mslive/100ms-roomkit-models-ios", branch:"development"),
        .package(url: "https://github.com/100mslive/Popovers", branch:"main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HMSRoomKit",
            dependencies: [
                "HMSHLSPlayerSDK", "Lottie", "Popovers",
                .product(name: "HMSRoomModels", package: "100ms-roomkit-models-ios"),
                .product(name: "HMSSDK", package: "100ms-roomkit-models-ios"),
                .product(name: "HMSAnalyticsSDK", package: "100ms-roomkit-models-ios"),
                .product(name: "WebRTC", package: "100ms-roomkit-models-ios")
                ],
            resources: [.process("audio-level-white.json")]
        ),
        .binaryTarget(
            name: "HMSHLSPlayerSDK",
            url: "https://github.com/100mslive/100ms-ios-hls-sdk/releases/download/0.0.2/HMSHLSPlayerSDK.xcframework.zip",
            checksum: "470932129c8dd358ebbe748bc1e05739f33c642779513fee17e42a117329dce2"
        ),
        .binaryTarget(
            name: "Lottie",
            url: "https://github.com/airbnb/lottie-ios/releases/download/4.2.0/Lottie.xcframework.zip",
            checksum: "4db3dee208f6213e5c1681f2314c7ed96d466d9b9adfe5cd0030309515075443"),
    ]
)
