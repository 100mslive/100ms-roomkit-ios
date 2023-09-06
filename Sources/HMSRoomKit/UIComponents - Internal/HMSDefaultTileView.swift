//
//  HMSDefaultTileView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 05/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

struct HMSDefaultTileView: View {
    
    @ObservedObject var peerModel: HMSPeerModel
    var compactMode: Bool = false
    
    var body: some View {
        HMSDefaultTileCommonView(compactMode: compactMode, color: peerModel.tileColor, text: peerModel.name.initials())
    }
}

struct HMSDefaultPreviewTileView: View {
    
    let peerName: String
    var compactMode: Bool = false
    
    var body: some View {
        
        HMSDefaultTileCommonView(compactMode: compactMode, color: Color(assetName: "random-\([1,2,3,4,5,6,7,8].randomElement()!)"), text: peerName.initials())
    }
}

private struct HMSDefaultTileCommonView: View {
    let compactMode: Bool
    let color: Color
    let text: String
    
    var body: some View {
        Circle()
            .frame(width: compactMode ? 54 : 88, height: compactMode ? 54 : 88)
            .foregroundColor(color)
            .overlay {
                if !text.isEmpty {
                    Text(text)
                        .font(.heading5Semibold24)
                        .foreground(.onSurfaceHigh)
                }
                else {
                    Image(assetName: "person-icon")
                }
            }
    }
}

extension String {
    func initials() -> String {
        let name = self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        var initials = ""
        let components = name.components(separatedBy: " ")
        
        if components.count > 1 {
            for component in components {
                if let firstLetter = component.first {
                    initials.append(firstLetter.uppercased())
                }
            }
        }
        else {
            initials = name.prefix(2).uppercased()
        }
        
        return initials
    }
}

struct HMSDefaultTileView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        VStack {
            HMSDefaultTileView(peerModel: HMSPeerModel(name: "Dix "))
                .environmentObject(HMSUITheme())
            
            HMSDefaultPreviewTileView(peerName: "Pawan Dixit")
                .environmentObject(HMSUITheme())
        }
#endif
    }
}
