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
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @Binding var isVirtualBackgroundControlsPresent: Bool
    
    @State var blurValue: CGFloat = 40
    
    var virtualBackgroundUrls: [URL]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HMSOptionsHeaderView(title: "Virtual Background", onClose: {
                withAnimation {
                    isVirtualBackgroundControlsPresent = false
                    dismiss()
                }
            })
            
            if let localPeerModel = roomModel.localPeerModel {
                HMSVideoTrackView(peer: localPeerModel, contentMode: .scaleAspectFit)
            }
            
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
                                            .frame(width: 30, height: 30)
                                        Text("No effect")
                                            .foreground(.onSurfaceMedium)
                                            .font(.captionRegular12)
                                    }
                                    .frame(width: 90, height: 80)
                                    .background(.surfaceBright, cornerRadius: 8)
                                    .onTapGesture {
                                        if roomModel.isVirtualBackgroundEnabled {
                                            try? roomModel.toggleVirtualBackground()
                                        }
                                    }
                                    
                                    VStack {
                                        Image(assetName: "blur-icon")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                        Text("Blur")
                                            .foreground(.onSurfaceMedium)
                                            .font(.captionRegular12)
                                    }
                                    .frame(width: 90, height: 80)
                                    .background(.surfaceBright, cornerRadius: 8)
                                    .onTapGesture {
                                        if !roomModel.isVirtualBackgroundEnabled {
                                            try? roomModel.toggleVirtualBackground()
                                        }
                                        try? roomModel.updateVirtualBackground(with: .blur(blurValue))
                                    }
                                }
                                
                            }
                            
                            if roomModel.isVirtualBackgroundEnabled, let virtualBackgroundOperatingMode = roomModel.virtualBackgroundOperatingMode, case .blur(_) = virtualBackgroundOperatingMode.mode {
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
                            }
                        }
                    }
                    .foreground(.onSurfaceHigh)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Backgrounds")
                            .font(.body2Semibold14)
                            .foreground(.onSurfaceHigh)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(virtualBackgroundUrls, id: \.self) { url in
                                
                                CachedAsyncImageView(url: url) { image in
                                    Task {
                                        if !roomModel.isVirtualBackgroundEnabled {
                                            try roomModel.toggleVirtualBackground()
                                        }
                                        try roomModel.updateVirtualBackground(with: .fixedImage(image))
                                    }
                                }
                                .cornerRadius(8)
                            }
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
    HMSVirtualBackgroundControlsSheetView(isVirtualBackgroundControlsPresent: .constant(true), virtualBackgroundUrls: [URL(string: "https://picsum.photos/200")!, URL(string: "https://picsum.photos/201")!, URL(string: "https://picsum.photos/202")!, URL(string: "https://picsum.photos/203")!, URL(string: "https://picsum.photos/204")!, URL(string: "https://picsum.photos/205")!])
        .environmentObject(HMSUITheme())
#if Preview
        .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
}
