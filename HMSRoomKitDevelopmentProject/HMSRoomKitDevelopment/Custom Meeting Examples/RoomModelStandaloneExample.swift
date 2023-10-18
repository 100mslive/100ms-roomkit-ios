//
//  CustomMeetingView.swift
//  HMSRoomKitDevelopment
//
//  Created by Pawan Dixit on 15/09/2023.
//

import SwiftUI
import HMSRoomModels
import ReplayKit

struct RoomModelStandaloneExample: View {
    
    @ObservedObject var roomModel = HMSRoomModel(roomCode: "qdw-mil-sev", options: .init(appGroupName: "group.live.100ms.videoapp.roomkit"))
    
    @StateObject var broadcastPickerView = {
        let picker = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        picker.showsMicrophoneButton = false
        return picker
    }()
    
    var body: some View {
        
        switch roomModel.roomState {
        case .notJoined, .leftMeeting:
            // Button to join the room
            Button {
                Task {
                    try await roomModel.joinSession(userName: "iOS User")
                }
            } label: {
                Text("Join")
            }
        case .inMeeting:
            VStack {
                List {
                    
                    // If a participant is sharing their screen, show their screen at the top of the list
                    if roomModel.peersSharingScreen.count > 0 {
                        TabView {
                            ForEach(roomModel.peersSharingScreen) { screenSharingPeer in
                                HMSScreenTrackView(peer: screenSharingPeer)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 200)
                    }
                        
                    // Render video of each peer in the call
                    ForEach(roomModel.peerModels) { peerModel in
                        
                        VStack {
                            Text(peerModel.name)
                            HMSVideoTrackView(peer: peerModel)
                                .frame(height: 200)
                        }
                    }
                    
                    List {
                        ForEach(roomModel.messages, id: \.self) { message in
                            Text("message")
                        }
                    }
                }
                
                HStack {
                    
                    // Toggle local user's mic
                    Image(systemName: roomModel.isMicMute ? "mic.slash" : "mic")
                        .onTapGesture {
                            roomModel.toggleMic()
                        }
                    
                    // Toggle local user's camera
                    Image(systemName: roomModel.isCameraMute ? "video.slash" : "video")
                        .onTapGesture {
                            roomModel.toggleCamera()
                        }
                    
                    // Share local user's screen from iOS
                    if roomModel.userCanShareScreen {
                        Image(systemName: "rectangle.inset.filled.and.person.filled")
                            .onTapGesture {
                                for subview in broadcastPickerView.subviews {
                                    if let button = subview as? UIButton {
                                        button.sendActions(for: UIControl.Event.allTouchEvents)
                                    }
                                }
                            }
                            .onAppear() {
                                broadcastPickerView.preferredExtension = "live.100ms.videoapp.roomkit.Screenshare"
                            }
                    }
                    
                    // Button to leave the room
                    Image(systemName: "phone.down.fill")
                        .onTapGesture {
                            Task {
                                try await roomModel.leaveSession()
                            }
                        }
                }
            }
        }
    }
}

struct RoomModelStandaloneExample_Previews: PreviewProvider {
    static var previews: some View {
        RoomModelStandaloneExample()
    }
}
