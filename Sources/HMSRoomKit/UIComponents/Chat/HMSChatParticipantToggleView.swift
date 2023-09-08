//
//  HMSChatParticipantToggleView.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 17.07.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSChatParticipantToggleView: View {
    
    @Environment(\.conferenceComponentParam) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @Environment(\.presentationMode) var presentationMode
    
    enum Pane: String, CaseIterable {
        case chat
        case participants
    }
    
    var initialPane: Pane = .chat
    
    @State private var selectedPane: Pane = .chat
  
    var body: some View {
        
        let isChatEnabled = conferenceComponentParam.chat != nil
        let isChatOverlay = conferenceComponentParam.chat?.isOverlay ?? false
        let isParticipantListEnabled = conferenceComponentParam.participantList != nil
        
        var panesToShow: [Pane] {
            var panes = [Pane]()
            if isChatEnabled && !isChatOverlay {
                panes.append(.chat)
            }
            if isParticipantListEnabled {
                panes.append(.participants)
            }
            return panes
        }
        
        if panesToShow.count > 0 {
            
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    HMSSegmentedControl( panesToShow,
                                         selection: selectedPane
                    ) { item in
                        Button {
                            withAnimation(.easeInOut(duration: 0.150)) {
                                selectedPane = item
                            }
                        } label: {
                            Text(item.rawValue.capitalized + (item == .participants ? " (\(roomModel.peerModels.count))" : ""))
                                .font(.body2Semibold14)
                                .foreground(selectedPane == item ? .onSurfaceHigh : .onSurfaceLow)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .pickerBackgroundColor(currentTheme.colorTheme.surfaceDefault)
                    .accentColor(currentTheme.colorTheme.surfaceBright)
                    .onAppear {
                        selectedPane = initialPane
                    }
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark").foreground(.onSurfaceMedium)
                    }
                }.padding(EdgeInsets(top: 24, leading: 16, bottom: 16, trailing: 16))
                
                switch selectedPane {
                case .chat:
                    HMSChatScreen()
                case .participants:
                    HMSParticipantListView()
                }
            }.background(.surfaceDim, cornerRadius: 0)
        }
    }
}

struct HMSChatParticipantToggleView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSChatParticipantToggleView().environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(5))
#endif
    }
}

