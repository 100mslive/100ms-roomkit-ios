//
//  HMSCaptionAdminOptionsView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 5/14/24.
//

import SwiftUI
import HMSRoomModels
import Combine

struct HMSCaptionAdminOptionsView: View {
    
    @EnvironmentObject var roomKitModel: HMSRoomNotificationModel
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.captionsState) var captionsState
    
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HMSOptionsHeaderView(title: roomModel.isTranscriptionStarted ? "Closed Captions (CC)" : "Enable Closed Captions (CC) for this session?", onClose: {
                dismiss()
            })
            .padding(.top, -16)
            VStack(alignment: .leading, spacing: 16) {
                
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

                            let note = HMSRoomKitNotification(id: UUID().uuidString, type: .closedCaptionStatus(icon: "loading-record"), actor: "", isDismissible: false, title: "Enabling Closed Captioning for everyone")
                            roomKitModel.addNotification(note)
                            
                            do {
                                cancellable = roomModel.$transcriptionStates.sink { transcriptionStates in
                                    
                                    guard let captionState = transcriptionStates.stateWith(mode: HMSTranscriptionMode.caption) else { return }
                                    if captionState.state == .started {
                                        roomKitModel.removeNotification(for: [note.id])
                                        cancellable = nil
                                    }
                                }
                                try await roomModel.startTranscription()
                                captionsState.wrappedValue = .visible
                            }
                            catch {
                                roomKitModel.removeNotification(for: [note.id])
                                roomKitModel.addNotification(HMSRoomKitNotification(id: UUID().uuidString, type: .error(icon: "warning-icon", retry: false, isTerminal: false), actor: "", isDismissible: true, title: "Failed to enable Closed Captions"))
                                cancellable = nil
                            }

                            dismiss()
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
                            let note = HMSRoomKitNotification(id: UUID().uuidString, type: .closedCaptionStatus(icon: "loading-record"), actor: "", isDismissible: false, title: "Disabling Closed Captioning for everyone")
                            roomKitModel.addNotification(note)
                            
                            do {
                                cancellable = roomModel.$transcriptionStates.sink { transcriptionStates in
                                    
                                    guard let captionState = transcriptionStates.stateWith(mode: HMSTranscriptionMode.caption) else { return }
                                    if captionState.state == .stopped {
                                        roomKitModel.removeNotification(for: [note.id])
                                        cancellable = nil
                                    }
                                }
                                try await roomModel.stopTranscription()
                            }
                            catch {
                                roomKitModel.removeNotification(for: [note.id])
                                cancellable = nil
                            }
                            
                            dismiss()
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
        .padding(.vertical, 24)
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
