//
//  HMSOptionSheetView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 03/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif

struct HMSDeviceSettingsSheetView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Speaker Settings")
                        .font(.heading6Semibold20)
                    
                    Spacer()
                    
                    HMSXMarkCircleView()
                        .onTapGesture {
                            isPresented = false
                        }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                
                Divider()
                    .background(.borderDefault, cornerRadius: 0)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Image(systemName: "speaker.wave.2")
                        Text("Speaker")
                        
                        Spacer(minLength: 0)
                    }
                    .padding(24)
                    .background(Color.black.opacity(0.0001))
                    .onTapGesture {
#if !Preview
                        try? roomModel.switchAudioOutput(to: .speaker)
#endif
                    }
                    
                    HStack {
                        Image(systemName: "phone")
                        Text("Phone")
                        
                        Spacer(minLength: 0)
                    }
                    .padding(24)
                    .background(Color.black.opacity(0.0001))
                    .onTapGesture {
#if !Preview
                        try? roomModel.switchAudioOutput(to: .speaker)
#endif
                    }
                    
                    HMSAirplayButton {
                        HStack {
                            Image(systemName: "speaker.wave.2")
                            Text("Other devices")
                            
                            Spacer(minLength: 0)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .foreground(.onSurfaceHigh)
        .background(.backgroundDim, cornerRadius: 8.0, ignoringEdges: .all)
    }
}

struct HMSDeviceSettingsSheetView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSDeviceSettingsSheetView(isPresented: .constant(true))
            .environmentObject(HMSUITheme())
#endif
    }
}
