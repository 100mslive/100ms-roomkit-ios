# 🎉 100ms RoomKit SDK ＆ Sample App 🚀

Roomkit SDK for iOS enables you to use our production ready Prebuilt conference and livestreaming UI in your own app.

👀 To see a Example App implementation of 100ms RoomKit SDK, checkout the [Example folder](https://github.com/100mslive/100ms-roomkit-ios/tree/main/HMSRoomKitExample)
  
## ☝️ Pre-requisites
- Xcode 14 or higher
- iOS 15 or higher

## Integration

Add RoomKit SDK as package dependency using **Swift Package Manager** built into Xcode. Use the following url as source for the package: https://github.com/100mslive/100ms-roomkit-ios.git

## Example usage

```swift
import SwiftUI
import HMSRoomKit

struct ContentView: View {
    var body: some View {
        HMSPrebuiltView(roomCode: /*pass room code as string here*/)
    }
}
```

### How to show Prebuilt UI conditionally from within your own views

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

### How to add screen sharing in Prebuilt

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

Where "group.live.100ms.videoapp.roomkit" is your App Group ID and "live.100ms.videoapp.roomkit.Screenshare" is your Broadcast Upload Extension's bundle ID. Additionally you'll also need to add a broadcast upload extension target to your app and hook it up with 100ms-ios-broadcast-sdk. You can follow the steps mentioned here: https://github.com/100mslive/100ms-ios-broadcast-sdk 
