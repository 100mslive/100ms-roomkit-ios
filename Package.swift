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
//        .package(url: "https://github.com/100mslive/100ms-ios-analytics-sdk", from: "0.0.2"),
        .package(url: "https://github.com/100mslive/Popovers", branch:"main"),
        .package(url: "https://github.com/100mslive/100ms-roomkit-models-ios", branch:"development")
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
                ]
        ),
//        .binaryTarget(
//            name: "HMSSDK",
//            url: "https://github.com/100mslive/100ms-ios-sdk/releases/download/0.9.10/HMSSDK.xcframework.zip",
//            checksum: "4263e4842d189b16131ea22365f909bb8228df1c0428aff83d49fdc321ec5970"
//        ),
//        .binaryTarget(
//            name: "HMSAnalyticsSDK",
//            url: "https://github.com/100mslive/100ms-ios-analytics-sdk/releases/download/0.0.2/HMSAnalyticsSDK.xcframework.zip",
//            checksum: "40229908576cac8afab7f9ba8b3bd9b1408f97f7bff63f83dca5b4f60f4378f0"
//        ),
//        .binaryTarget(
//            name: "WebRTC",
//            url: "https://github.com/100mslive/webrtc-ios/releases/download/1.0.5116/WebRTC.xcframework.zip",
//            checksum: "5f38579bb743b089d95017fa56dc76f8e3e440dbdd56061db04c26448262cfee"
//        ),
        .binaryTarget(
            name: "HMSHLSPlayerSDK",
            url: "https://github.com/100mslive/100ms-ios-hls-sdk/releases/download/0.0.2/HMSHLSPlayerSDK.xcframework.zip",
            checksum: "470932129c8dd358ebbe748bc1e05739f33c642779513fee17e42a117329dce2"
        ),
        .binaryTarget(
            name: "Lottie",
            url: "https://github.com/airbnb/lottie-ios/releases/download/4.2.0/Lottie.xcframework.zip",
            checksum: "4db3dee208f6213e5c1681f2314c7ed96d466d9b9adfe5cd0030309515075443"),
//        .target(name: "HMSRoomKitDependencies", dependencies: [
//            "HMSHLSPlayerSDK", "Lottie",
//            .product(name: "HMSRoomModels", package: "100ms-roomkit-models-ios"),
//            .product(name: "HMSSDK", package: "100ms-roomkit-models-ios"),
//            .product(name: "HMSAnalyticsSDK", package: "100ms-roomkit-models-ios"),
//            .product(name: "WebRTC", package: "100ms-roomkit-models-ios")
//            ], path: "dependencies")
    ]
)
