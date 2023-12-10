# 🎉 100ms RoomKit SDK ＆ Sample App 🚀

RoomKit SDK for iOS enables you to integrate our production-ready conferencing and livestreaming UI into your own app effortlessly. This README will guide you through the integration process and provide examples of common use cases.
  
## Pre-requisites
- **100ms account**: You will need a 100ms account to create rooms and generate tokens. If you don't have one yet, you can create it [here](https://dashboard.100ms.live/register). Once you've created an account, you can generate [room-codes](https://www.100ms.live/docs/get-started/v2/get-started/prebuilt/room-codes/overview) and [auth-tokens](https://www.100ms.live/docs/get-started/v2/get-started/security-and-tokens#auth-token-for-client-sdks) following the provided guides.
- Xcode 14 or higher
- iOS 15 or higher
- NSMicrophoneUsageDescription (ie. Privacy - Microphone Usage Description) in info.plist of your app
- NSCameraUsageDescription (ie. Privacy - Camera Usage Description) in info.plist of your app

👀 To see an example app implementation of a conferencing/livestreaming app using 100ms RoomKit SDK, checkout the [example repository](https://github.com/100mslive/100ms-roomkit-example).

To experience the example app made using RoomKit, you can download the app from **TestFlight** to your iOS device here: https://testflight.apple.com/join/Pb4aTS0t

## Integration

You can integrate RoomKit SDK into your project using Swift Package Manager (SPM). Follow these steps:

1. Open your Xcode project.
2. Navigate to `File` > `Add Package Dependency`.
3. In the dialog that appears, enter the following URL as the package source: https://github.com/100mslive/100ms-roomkit-ios.git
4. Click `Next` and follow the prompts to add the package to your project.

## RoomKit Basics

### Import SDK
You import the RoomKit SDK with following import statement

```swift
import HMSRoomKit
```

### Instantiate HMSPrebuiltView
You use SwiftUI view called HMSPrebuiltView to instantiate a production-ready conferencing and livestreaming UI. You can either pass a [room-code](https://www.100ms.live/docs/get-started/v2/get-started/prebuilt/room-codes/overview) or an [auth-token](https://www.100ms.live/docs/get-started/v2/get-started/security-and-tokens#auth-token-for-client-sdks) to HMSPrebuiltView.

#### Initialize HMSPrebuiltView with a room code

```swift
// Initialize with room code
HMSPrebuiltView(roomCode: /*pass room code as string here*/)
```

#### Initialize HMSPrebuiltView with an auth token

```swift
// Initialize with auth token
HMSPrebuiltView(token: /*pass role's auth token as string here*/)
```

## Example usage

### Fully Featured Conferencing/Livestreaming App with Room Code

To create a fully-featured conferencing/Livestreaming app with just a room code for a role, use the following code snippet. Make sure to pass a valid room code as a string:

```swift
import SwiftUI
import HMSRoomKit

struct ContentView: View {
    var body: some View {
        HMSPrebuiltView(roomCode: /*pass room code as string here*/)
    }
}
```

### Fully Featured Conferencing/Livestreaming App with Auth Token

To create a fully-featured conferencing/Livestreaming app with just an Auth Token for a role, use the following code snippet. Pass the role's auth token as a string:

```swift
import SwiftUI
import HMSRoomKit

struct ContentView: View {
    var body: some View {
        HMSPrebuiltView(token: /*pass role's auth token as string here*/)
    }
}
```

Following demo video shows you how to integrate RoomKit SDK in your app by follwing instructions above

![Demo Video](https://github.com/100mslive/100ms-roomkit-ios/assets/103245157/9947e072-af6c-4381-80af-8128c82f3f2c)

### Adding Screen Sharing Feature

To add screen sharing to your app that uses Prebuilt, follow these steps:

1. Use the code snippet below, replacing the placeholders with your App Group ID and Broadcast Upload Extension's bundle ID:

```swift
import SwiftUI
import HMSRoomKit

struct ContentView: View {
    var body: some View {
        HMSPrebuiltView(roomCode: "qsw-mik-seb")
          .screenShare(appGroupName: "group.live.100ms.videoapp.roomkit", screenShareBroadcastExtensionBundleId: "live.100ms.videoapp.roomkit.Screenshare")
    }
}
```

2. Ensure you have set up a broadcast upload extension target in your app and connected it with 100ms-ios-broadcast-sdk. For detailed instructions, refer to [this guide](https://github.com/100mslive/100ms-ios-broadcast-sdk).

### Showing Prebuilt Screen Conditionally

To conditionally display the Prebuilt Screen from other views in your app, use the following code snippet:

```swift
import SwiftUI
import HMSRoomKit

struct ContentView: View {
    
    @State var roomCode = ""
    @State var isMeetingViewPresented = false
    
    var body: some View {
        
        if isMeetingViewPresented && !roomCode.isEmpty {
            
            HMSPrebuiltView(roomCode: roomCode, onDismiss: {
                isMeetingViewPresented = false
            })
        }
        else {
            VStack {
                TextField("Enter Room Code", text: $roomCode)
                Button {
                    isMeetingViewPresented.toggle()
                } label: {
                    Text("Join")
                }
            }
        }
    }
}
```

This code allows you to conditionally display the Prebuilt Screen based on user input.

# How to make changes, debug, preview and contribute to RoomKit

1. Clone https://github.com/100mslive/100ms-roomkit-ios, https://github.com/100mslive/100ms-roomkit-models-ios and https://github.com/100mslive/100ms-roomkit-example in same folder.
2. Open **HMSRoomKitDevelopmentProject** Xcode project inside **100ms-roomkit-example** repo.

<img width="906" alt="Screenshot 2023-11-20 at 2 15 02 PM" src="https://github.com/100mslive/100ms-roomkit-ios/assets/103245157/ab54a8e5-8884-44d6-80b5-b844a91eded8">

3. In HMSRoomKitDevelopmentProject Xcode project, use **HMSRoomKitDevelopment** target scheme to run the app in simulator or device. Use **HMSRoomKitPreview** target to see SwiftUI preview of files under **HMSRoomKit folder** (HMSRoomKit source files).

<img width="348" alt="Screenshot 2023-09-13 at 5 44 58 PM" src="https://github.com/100mslive/100ms-roomkit-ios/assets/103245157/dff9264c-966f-4487-bb1c-a7d3d0f22b0b">

5. Before making changes, drag and drop local instances of 100ms-roomkit-ios and 100ms-roomkit-models-ios repo to Xcode so that development project uses editable version of the local SPM repo. You can make changes to files in HMSRoomKit folder (**HMSRoomKit source files**) or HMSRoomModels folder (**HMSRoomModels source files**) to add a feature/improvement or fix any issue.

<img width="317" alt="Screenshot 2023-11-20 at 2 16 21 PM" src="https://github.com/100mslive/100ms-roomkit-ios/assets/103245157/41415b08-1093-4372-b47a-8a6225350cab">

7. Once you are done, create PRs with your changes to **main branch** of **respective repos**.

<img width="993" alt="Screenshot 2023-09-13 at 5 51 01 PM" src="https://github.com/100mslive/100ms-roomkit-ios/assets/103245157/d1102bde-e081-4857-af2b-4bb969feeffb">
