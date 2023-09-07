//
//  HMSLeaveCallOptionsView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 31/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSRoomModels

struct HMSLeaveCallOptionsView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @State var isLeaveSheetPresented = false
    @State var isEndCallSheetPresented = false
    
    var body: some View {
        
        let isBeingStreamed = roomModel.isBeingStreamed
        
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 16) {
                Image(assetName: "leave-icon")
                    .foreground(.onSurfaceHigh)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Leave")
                        .foreground(.onSurfaceHigh)
                        .font(.heading6Semibold20)
                    
                    Text("Others will continue after you leave. You can join the session again.")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.body2Regular14)
                        .foreground(.onSurfaceLow)
                }
                Spacer()
            }
            .padding(24)
            .background(.surfaceDim, cornerRadius: 0)
            .onTapGesture {
                isLeaveSheetPresented.toggle()
            }
            
            HStack(alignment: .top, spacing: 16) {
                Image(assetName: "stop-stream-icon")
                    .frame(width: 24, height: 24)
                    .foreground(.errorBrighter)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(isBeingStreamed ? "End Session" : "End for All")
                        .font(.heading6Semibold20)
                        .foreground(.errorBrighter)
                    
                    
                    Text(isBeingStreamed ? "The session and stream will end for everyone. You can’t undo this action." : "The session will end for everyone. You can’t undo this action.")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.body2Regular14)
                        .foreground(.errorBright)
                }
                Spacer()
            }
            .padding(24)
            .background(.errorDim, cornerRadius: 0)
            .onTapGesture {
                isEndCallSheetPresented.toggle()
            }
        }
        .sheet(isPresented: $isLeaveSheetPresented) {
            HMSSheet {
                HMSLeaveCallView()
            }
            .edgesIgnoringSafeArea(.all)
            .environmentObject(currentTheme)
        }
        .sheet(isPresented: $isEndCallSheetPresented) {
            HMSSheet {
                HMSEndCallView()
            }
            .edgesIgnoringSafeArea(.all)
            .environmentObject(currentTheme)
        }
    }
}

struct HMSLeaveCallOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSLeaveCallOptionsView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
