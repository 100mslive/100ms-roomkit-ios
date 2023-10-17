//
//  CustomMeetingView.swift
//  HMSRoomKitDevelopment
//
//  Created by Pawan Dixit on 15/09/2023.
//

import SwiftUI
import HMSRoomModels

struct RoomModelStandaloneExample: View {
    
    @ObservedObject var roomModel = HMSRoomModel(roomCode: "qdw-mil-sev")
    
    var body: some View {
        
        Group {
            switch roomModel.roomState {
            case .none, .leave:
                Button(action: {
                    Task {
                        try await roomModel.joinSession(userName: "iOS User")
                    }
                }, label: {
                    Text("Join")
                })
            case .meeting:
                VStack {
                    List {
                        ForEach(roomModel.peerModels) { peerModel in
                            
                            VStack {
                                Text(peerModel.name)
                                HMSVideoTrackView(peer: peerModel)
                                    .frame(height: 200)
                            }
                        }
                    }
                    
                    HStack(spacing: 30) {
                        Spacer()
                        Image(systemName: roomModel.isMicMute ? "mic.slash" : "mic")
                            .onTapGesture {
                                roomModel.toggleMic()
                            }
                        
                        Image(systemName: roomModel.isCameraMute ? "video.slash" : "video")
                            .onTapGesture {
                                roomModel.toggleCamera()
                            }
                        
                        Image(systemName: "phone.down.fill")
                            .onTapGesture {
                                Task {
                                    try await roomModel.leaveSession()
                                }
                            }
                        Spacer()
                    }
                    .padding()
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
