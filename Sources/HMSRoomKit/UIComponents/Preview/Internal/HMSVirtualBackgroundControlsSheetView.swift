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
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    @State var blurValue: CGFloat = 40
    
    var virtualBackgroundUrls: [URL]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        if verticalSizeClass == .regular {
            
            VStack(spacing: 0) {
                
                HMSOptionsHeaderView(title: "Virtual Background", onClose: {
                    withAnimation {
                        dismiss()
                    }
                })
                
                videoTrackView
                
                vbControlsView
            }
            .background(.surfaceDim, cornerRadius: 8, ignoringEdges: .all)
        }
        else {
            HStack(spacing: 0) {
                
                videoTrackView
                
                VStack(spacing: 0) {
                    HMSOptionsHeaderView(title: "Virtual Background", onClose: {
                        withAnimation {
                            dismiss()
                        }
                    })
                    
                    vbControlsView
                }
            }
            .background(.surfaceDim, cornerRadius: 8, ignoringEdges: .all)
        }
    }
    
    @ViewBuilder
    var videoTrackView: some View {
        if let videoTrack = roomModel.localVideoTrackModel {
            HMSPeerVideoTrackView(trackModel: videoTrack, contentMode: .scaleAspectFit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var vbControlsView: some View {
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
                                .overlay {
                                    if !roomModel.isVirtualBackgroundEnabled {
                                        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2)
                                            .foreground(.primaryDefault)
                                    }
                                }
                                .padding(5)
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
                                .overlay {
                                    if roomModel.isVirtualBackgroundEnabled, case .blur(_) = roomModel.virtualBackgroundOperatingMode?.mode {
                                        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2)
                                            .foreground(.primaryDefault)
                                    }
                                }
                                .padding(5)
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
                            VBImageView(url: url)
                        }
                    }
                }
            }
            .padding(.top, 16)
        }
        .padding(.horizontal)
        .animation(.default, value: roomModel.virtualBackgroundOperatingMode)
        .animation(.default, value: roomModel.isVirtualBackgroundEnabled)
    }
    
    struct VBImageView: View {
        
        @EnvironmentObject var roomModel: HMSRoomModel
        
        let url: URL
        
        @State var loadedImage: UIImage?
        
        var body: some View {
            CachedAsyncImageView(url: url, onLoaded: { image in
                loadedImage = image
            }) { image in
                Task {
                    if !roomModel.isVirtualBackgroundEnabled {
                        try roomModel.toggleVirtualBackground()
                    }
                    try roomModel.updateVirtualBackground(with: .fixedImage(image))
                }
            }
            .cornerRadius(8)
            .overlay {
                if roomModel.isVirtualBackgroundEnabled, case .fixedImage(let fixedImage) = roomModel.virtualBackgroundOperatingMode?.mode {
                    if loadedImage == fixedImage {
                        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 2)
                            .foreground(.primaryDefault)
                    }
                }
            }
            .padding(5)
        }
    }
}

#Preview {
    HMSVirtualBackgroundControlsSheetView(virtualBackgroundUrls: [URL(string: "https://picsum.photos/200")!, URL(string: "https://picsum.photos/201")!, URL(string: "https://picsum.photos/202")!, URL(string: "https://picsum.photos/203")!, URL(string: "https://picsum.photos/204")!, URL(string: "https://picsum.photos/205")!])
        .environmentObject(HMSUITheme())
#if Preview
        .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
}
