//
//  HMSMicToggle.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 15/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSEndCallButton: View {
    
    @Environment(\.menuContext) var menuContext
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State var isOptionsPresented = false
    @State var isLeaveSheetPresented = false
    @State var isEndCallSheetPresented = false
    
    @State var leaveContext = EnvironmentValues.LeaveContext.none
    
    var type: HMSEndCallButtonView.ButtonType
    
    var body: some View {
        
        let canEndRoom = roomModel.userCanEndRoom
        let isBeingStreamed = roomModel.isBeingStreamed
        let userCanStartStopHLSStream = roomModel.userCanStartStopHLSStream
        
        HMSEndCallButtonView(type: type)
            .onTapGesture {
                if canEndRoom {
                    if isBeingStreamed {
                        if userCanStartStopHLSStream {
                            isOptionsPresented.toggle()
                        }
                        else {
                            isLeaveSheetPresented.toggle()
                        }
                    }
                    else {
                        isOptionsPresented.toggle()
                    }
                }
                else {
                    isLeaveSheetPresented.toggle()
                }
            }
            .sheet(isPresented: $isOptionsPresented) {
                HMSSheet {
                    HMSLeaveCallOptionsView()
                }
                .edgesIgnoringSafeArea(.all)
                .background(.surfaceDim, cornerRadius: 0)
            }
            .sheet(isPresented: $isLeaveSheetPresented) {
                HMSSheet {
                    HMSLeaveCallView()
                }
                .edgesIgnoringSafeArea(.all)
                .environmentObject(currentTheme)
            }
    }
}

struct HMSEndCallButton_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSEndCallButton(type: .webrtc)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(1))
#endif
    }
}
