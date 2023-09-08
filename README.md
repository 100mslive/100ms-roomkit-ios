# 🎉 100ms RoomKit SDK ＆ Sample App 🚀

Roomkit SDK for iOS enables you to use our production ready Prebuilt conference and livestreaming UI in your own app.

👀 To see a Example App implementation of 100ms RoomKit SDK, checkout the [Example folder](https://github.com/100mslive/100ms-roomkit-ios/tree/main/HMSRoomKitExample)
  
## ☝️ Pre-requisites
- Xcode 14 or higher
- iOS 15 or higher

## Integration

Add RoomKit SDK with **Swift Package Manager** using the following url as source: https://github.com/100mslive/100ms-roomkit-ios.git

## Example usage

```swift

struct ContentView: View {
    var body: some View {
        HMSPrebuiltView(roomCode: /*pass room code as string here*/)
    }
}

```
