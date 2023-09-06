// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HMSRoomKit",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HMSRoomKit",
            targets: ["HMSRoomKit", "WebRTC", "HMSRoomKitDependencies"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
//        .package(url: "https://github.com/100mslive/100ms-ios-sdk", from: "0.9.10")
        .package(name: "HMSAnalyticsSDK", url: "https://github.com/100mslive/100ms-ios-analytics-sdk", from: "0.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HMSRoomKit",
            dependencies: []),
        .testTarget(
            name: "HMSRoomKitTests",
            dependencies: ["HMSRoomKit"]),
        .binaryTarget(
            name: "HMSSDK",
            url: "https://github.com/100mslive/100ms-ios-sdk/releases/download/0.9.10/HMSSDK.xcframework.zip",
            checksum: "4263e4842d189b16131ea22365f909bb8228df1c0428aff83d49fdc321ec5970"
        ),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/100mslive/webrtc-ios/releases/download/1.0.5116/WebRTC.xcframework.zip",
            checksum: "5f38579bb743b089d95017fa56dc76f8e3e440dbdd56061db04c26448262cfee"
        ),
        .target(name: "HMSRoomKitDependencies", dependencies: ["HMSAnalyticsSDK"], path: "dependencies")
    ]
)
