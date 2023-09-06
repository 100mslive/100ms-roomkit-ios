//
//  HMSMessageOptionsView.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 27.07.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSMessageOptionsView: View {
    enum Action: Equatable {
    case pin
    case copy
    case none
    }
    
    @Binding var action: Action
    @Binding var isPresented: Bool
    @EnvironmentObject var currentTheme: HMSUITheme
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(assetName: "pin").frame(width: 20, height: 20)
                Text("Pin Message").font(.subtitle2Semibold14)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .onTapGesture {
                action = .none
                action = .pin
                isPresented = false
            }
            HMSDivider(color: currentTheme.colorTheme.borderBright).frame(width: 172)
            HStack {
                Image(assetName: "copy").frame(width: 20, height: 20)
                Text("Copy Message").font(.subtitle2Semibold14)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .onTapGesture {
                action = .none
                action = .copy
                isPresented = false
            }
            
             
        }
        .foreground(.onSurfaceHigh)
        .background(.surfaceDefault, cornerRadius: 8, border: .borderBright)
    }
}

struct HMSMessageOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSMessageOptionsView(action: .constant(.copy), isPresented: .constant(true))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
