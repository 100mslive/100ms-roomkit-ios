//
//  HMSCaptionAdminOptionsView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 5/14/24.
//

import SwiftUI

struct HMSCaptionAdminOptionsView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.captionsState) var captionsState
    
    var body: some View {
        
        if captionsState.wrappedValue != .failed && captionsState.wrappedValue != .initializing {
            
            VStack(alignment: .leading) {
                
                HMSOptionsHeaderView(title: captionsState.wrappedValue == .notStarted ? "Enable Closed Captions (CC) for this session?" : "Closed Captions (CC)", onClose: {
                    dismiss()
                })
                VStack(alignment: .leading) {
                    
                    if captionsState.wrappedValue == .notStarted {
                        HStack(alignment: .top, spacing: 16) {
                            Text("Enable for Everyone")
                                .foreground(.onPrimaryHigh)
                                .font(.buttonSemibold16)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.primaryDefault, cornerRadius: 8)
                        .onTapGesture {
                            
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
                            
                        }
                    }
                    
                    Text(captionsState.wrappedValue == .notStarted ? "This will enable Closed Captions for everyone in this room. You can disable it later." : "This will disable Closed Captions for everyone in this room. You can enable it again.")
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
            .environment(\.captionsState, .constant(.notStarted))
#endif
    }
}
