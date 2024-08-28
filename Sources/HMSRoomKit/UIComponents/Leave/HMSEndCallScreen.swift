//
//  HMSEndCallScreen.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 20/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

public struct HMSEndCallScreen: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    
    var onDismiss: (() -> Void)? = nil
    
    public init(onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
    }
    
    @State var isFeedbackSheetPresented = false
    
    public var body: some View {
        VStack {
            
            HStack {
                Spacer()
                
                HMSXMarkCircleView()
                    .padding()
                    .onTapGesture {
                        // dismiss if we are running as sheet
                        onDismiss?()
                        
                        // reset room state if not dismissed
                        roomModel.roomState = .notJoined
                    }
            }
            
            Spacer()
            
            VStack(spacing: 48) {
                
                VStack(spacing: 24) {
                    Image(assetName: "hello-icon")
                        .resizable()
                        .foreground(.alertWarning)
                        .frame(width: 64, height: 64)
                    
                    VStack(spacing: 8) {
                        Text("You left the meeting")
                            .font(.heading5Semibold24)
                            .foreground(.onSurfaceHigh)
                        
                        Text("Have a nice day!")
                            .font(.body1Regular16)
                            .foreground(.onSurfaceMedium)
                    }
                }
                
                if case .leftMeeting(let reason) = roomModel.roomState {
                    switch reason {
                    case .userLeft, .removedFromRoom:
                        VStack(spacing: 16) {
                            Text("Left by mistake?")
                                .font(.body2Regular14)
                                .foreground(.onSurfaceMedium)
                            
                            HStack {
                                Image(assetName: "join-icon")
                                    .font(.buttonSemibold16)
                                Text("Rejoin")
                                    .font(.buttonSemibold16)
                            }
                            .foreground(.onPrimaryHigh)
                            .padding(16)
                            .background(.primaryDefault, cornerRadius: 8)
                            .onTapGesture {
                                roomModel.roomState = .notJoined
                            }
                        }
                    case .roomEnded:
                        EmptyView()
                    }
                }
            }
            .minimumScaleFactor(0.3)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
        .sheet(isPresented: $isFeedbackSheetPresented, content: {
            HMSSheet {
                if let feedback = roomInfoModel.defaultLeaveScreen?.elements?.feedback {
                    HMSCallFeedbackView(feedback: feedback)
                }
            }
            .edgesIgnoringSafeArea(.all)
        })
        .onAppear() {
            isFeedbackSheetPresented = (roomInfoModel.defaultLeaveScreen?.elements?.feedback != nil)
        }
    }
}

struct HMSEndCallScreen_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSEndCallScreen()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
