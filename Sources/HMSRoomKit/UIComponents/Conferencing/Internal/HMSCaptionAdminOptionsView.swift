//
//  HMSCaptionAdminOptionsView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 5/14/24.
//

import SwiftUI
import HMSRoomModels

struct HMSCaptionAdminOptionsView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.captionsState) var captionsState
    
    var body: some View {
        
        if captionsState.wrappedValue != .failed && captionsState.wrappedValue != .starting {
            
            VStack(alignment: .leading) {
                
                HMSOptionsHeaderView(title: roomModel.isTranscriptionStarted ? "Closed Captions (CC)" : "Enable Closed Captions (CC) for this session?", onClose: {
                    dismiss()
                })
                VStack(alignment: .leading) {
                    
                    if !roomModel.isTranscriptionStarted {
                        HStack(alignment: .top, spacing: 16) {
                            Text("Enable for Everyone")
                                .foreground(.onPrimaryHigh)
                                .font(.buttonSemibold16)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.primaryDefault, cornerRadius: 8)
                        .onTapGesture {
                            Task {
                                try await roomModel.startTranscription()
                                dismiss()
                            }
                        }
                    }
                    else {
                        HStack(alignment: .top, spacing: 16) {
                            Text(captionsState.wrappedValue == .visible ? "Hide for Me" : "Show for Me")
                                .foreground(.onSecondaryHigh)
                                .font(.buttonSemibold16)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.secondaryDefault, cornerRadius: 8)
                        .onTapGesture {
                            captionsState.wrappedValue = captionsState.wrappedValue == .visible ? .hidden : .visible
                            dismiss()
                        }
                        
                        HStack(alignment: .top, spacing: 16) {
                            Text("Disable for Everyone")
                                .foreground(.errorBrighter)
                                .font(.buttonSemibold16)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.errorDefault, cornerRadius: 8)
                        .onTapGesture {
                            Task {
                                try await roomModel.stopTranscription()
                                dismiss()
                            }
                        }
                    }
                    
                    Text(!roomModel.isTranscriptionStarted ? "This will enable Closed Captions for everyone in this room. You can disable it later." : "This will disable Closed Captions for everyone in this room. You can enable it again.")
                        .foreground(.onSurfaceMedium)
                        .font(.body2Regular14)
                    
                }
                .padding(.horizontal, 24)
                
            }
        }
    }
}

struct HMSCaptionAdminOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSCaptionAdminOptionsView()
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environment(\.captionsState, .constant(.hidden))
#endif
    }
}
