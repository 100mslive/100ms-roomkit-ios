//
//  SwiftUIView.swift
//  
//
//  Created by Pawan Dixit on 12/11/23.
//

import SwiftUI
import HMSHLSPlayerSDK

struct HMSHLSPlayerControlsView: View {
    
    let player: HMSHLSPlayer
    
    @State var isPopoverPresented = false
    
    var body: some View {
        Color.clear
            .onReceive(NotificationCenter.default.publisher(for: .init(rawValue: "hls-quality-picker"))) { _ in
                
                isPopoverPresented.toggle()
            }
            .overlay(alignment: .topTrailing) {
//                Image(assetName: "gear-icon")
//                    .resizable()
//                    .foreground(.white)
//                    .frame(width: 32, height: 32)
//                    .padding()
//                    .onTapGesture {
//                        isPopoverPresented.toggle()
//                    }
                    
            }
            .sheet(isPresented: $isPopoverPresented) {
                HMSSheet {
                    HMSHLSQualityPickerView(player: player)
                }
                .edgesIgnoringSafeArea(.all)
            }
    }
}

struct HMSHLSPlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSHLSPlayerControlsView(player: HMSHLSPlayer())
            .environmentObject(HMSUITheme())
            .environment(\.colorScheme, .dark)
#endif
    }
}
