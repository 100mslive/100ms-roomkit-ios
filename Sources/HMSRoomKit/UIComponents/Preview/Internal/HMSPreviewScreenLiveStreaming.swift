//
//  PreviewScreen.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSPreviewScreenLiveStreaming: View {
    
    @Namespace private var animation
    
    @Environment(\.previewParams) var previewComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @State var name: String = ""
//    @State private var keyboardOffset: CGFloat = 0.0
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            if roomModel.localVideoTrackModel != nil {
                
                HMSPreviewTile()
                    .ignoresSafeArea(.keyboard)
                    .edgesIgnoringSafeArea([.top, .bottom])
                    .overlay(alignment: .top) {
                        HMSPreviewTopOverlay()
                            .padding(.vertical, 8)
                            .matchedGeometryEffect(id: "HMSPreviewTopOverlay", in: animation)
                            .background (
                                LinearGradient(
                                    gradient: Gradient(colors: [currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(1.0), currentTheme.colorTheme.colorForToken(.backgroundDim).opacity(0.0)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
            }
            else {
                VStack {
                    Spacer(minLength: 0)
                    HMSPreviewTopOverlay()
                        .matchedGeometryEffect(id: "HMSPreviewTopOverlay", in: animation)
                    Spacer(minLength: 0)
                }
            }
        }
        .overlay(alignment: .top) {
            HStack {
                HMSBackButtonView()
                    .padding(.leading)
                    .onTapGesture {
                        Task {
#if !Preview
                            try await roomModel.leaveSession()
#endif
                        }
                    }
                Spacer()
            }
        }
        .overlay(alignment: .bottom) {
            
            VStack {
                
                if let localPeerModel = roomModel.localPeerModel {
                    HStack {
                        HMSPreviewNameLabel(peerModel: localPeerModel)
                            .padding(9)
                        
                        Spacer(minLength: 0)
                    }
                }
                
                HMSPreviewBottomOverlay()
                        .matchedGeometryEffect(id: "HMSPreviewBottomOverlay", in: animation)
            }
        }
        .animation(.default, value: roomModel.localVideoTrackModel)
        .background(.white.opacity(0.0001))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        //        .offset(y: keyboardOffset)
        .background(.backgroundDim, cornerRadius: 0, ignoringEdges: .all)
        .alert(isPresented: Binding(get: {
            guard let lastError = roomModel.lastError as? HMSError else { return false }
            return lastError.isTerminal
        }, set: { _ in
            Task {
                try await roomModel.leaveSession()
            }
        }), content: {
            Alert(title: Text("Error"), message: Text(roomModel.lastError?.localizedDescription ?? ""))
        })
        //        .ignoresSafeArea(.keyboard)
//        .onAppear {
//            
//            // Doing this avoids retain cycle in observers below
//            let keyboardOffset = $keyboardOffset
//            
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
//                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//                let keyboardHeight = keyboardFrame.height
//                
//                withAnimation {
//                    keyboardOffset.wrappedValue = -keyboardHeight
//                }
//            }
//            
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//                withAnimation {
//                    keyboardOffset.wrappedValue = 0.0
//                }
//            }
//        }
    }
}

struct HMSPreviewScreenLiveStreaming_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSPreviewScreenLiveStreaming()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
