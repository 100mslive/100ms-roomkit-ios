//
//  HMSVirtualBackgroundControlsSheetView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 6/24/24.
//

import SwiftUI
import HMSRoomModels
import HMSSDK

struct HMSVirtualBackgroundControlsSheetView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Binding var isVirtualBackgroundControlsPresent: Bool
    
    @State var blurValue: CGFloat = 40
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HMSOptionsHeaderView(title: "Virtual Background", onClose: {
                withAnimation {
                    isVirtualBackgroundControlsPresent = false
                }
            })
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Effects")
                            .font(.body2Semibold14)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    VStack {
                                        Image(assetName: "diag-cross-xl")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        Text("No effect")
                                            .foreground(.onSurfaceMedium)
                                            .font(.captionRegular12)
                                    }
                                    .frame(width: 90, height: 90)
                                    .background(.surfaceBright, cornerRadius: 8)
                                    .onTapGesture {
                                        if roomModel.isVirtualBackgroundEnabled {
                                            try? roomModel.toggleVirtualBackground()
                                        }
                                    }
                                    
                                    VStack {
                                        Image(assetName: "blur-icon")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        Text("Blur")
                                            .foreground(.onSurfaceMedium)
                                            .font(.captionRegular12)
                                    }
                                    .frame(width: 90, height: 90)
                                    .background(.surfaceBright, cornerRadius: 8)
                                    .onTapGesture {
                                        if !roomModel.isVirtualBackgroundEnabled {
                                            try? roomModel.toggleVirtualBackground()
                                        }
                                        try? roomModel.updateVirtualBackground(with: .blur(blurValue))
                                    }
                                }
                                
                            }
                            
//                            if roomModel.isVirtualBackgroundEnabled, let virtualBackgroundOperatingMode = roomModel.virtualBackgroundOperatingMode, case .blur(_) = virtualBackgroundOperatingMode.mode {
                                HStack {
                                    
                                    Image(assetName: "blur-decrease")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                    Slider(value: $blurValue, in: 0...100, step: 10)
                                        .controlSize(.small)
                                        .onChange(of: blurValue) { newValue in
                                            try? roomModel.updateVirtualBackground(with: .blur(newValue))
                                        }
                                    
                                    Image(assetName: "blur-increase")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
//                            }
                        }
                    }
                    .foreground(.onSurfaceHigh)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Backgrounds")
                            .font(.body2Semibold14)
                            .foreground(.onSurfaceHigh)
                        
                        VStack {
                            
                        }
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal)
        }
        .background(.surfaceDim, cornerRadius: 8, ignoringEdges: .all)
    }
}

#Preview {
    HMSVirtualBackgroundControlsSheetView(isVirtualBackgroundControlsPresent: .constant(true))
        .environmentObject(HMSUITheme())
}
