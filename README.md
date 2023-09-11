# 🎉 100ms RoomKit SDK ＆ Sample App 🚀

RoomKit SDK for iOS enables you to integrate our production-ready conferencing and livestreaming UI into your own app effortlessly. This README will guide you through the integration process and provide examples of common use cases.
  
## ☝️ Pre-requisites
- Xcode 14 or higher
- iOS 15 or higher
- NSMicrophoneUsageDescription (ie. Privacy - Microphone Usage Description) in info.plist of your app
- NSCameraUsageDescription (ie. Privacy - Camera Usage Description) in info.plist of your app

👀 To see an example app implementation of a conferencing/livestreaming app using 100ms RoomKit SDK, checkout the [example folder](https://github.com/100mslive/100ms-roomkit-ios/tree/main/HMSRoomKitExample).

## Integration

You can integrate RoomKit SDK into your project using Swift Package Manager (SPM). Follow these steps:

1. Open your Xcode project.
2. Navigate to `File` > `Add Package Dependency`.
3. In the dialog that appears, enter the following URL as the package source: https://github.com/100mslive/100ms-roomkit-ios.git
4. Click `Next` and follow the prompts to add the package to your project.

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
