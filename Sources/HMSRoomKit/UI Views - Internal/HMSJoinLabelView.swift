//
//  JoinbuttonView.swift
//  HMSRoomKit
//
//  Created by Pawan Dixit on 12/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif
import HMSRoomModels

struct HMSJoinLabelView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @Environment(\.previewComponentParam) var previewComponentParam
    
    let userName: String
    @Binding var isJoining: Bool
    
    var body: some View {
        Group   {
            if isJoining {
                HMSLoadingView {
                    Image(assetName: "loading-join")
                }
            }
            else {
                HStack {
                    if previewComponentParam.joinButtonType == .goLive && !roomModel.isBeingStreamed {
                        
                        Image(assetName: "golive-icon")
                        
                        Text(previewComponentParam.goLiveButtonLabel)
                            .font(.buttonSemibold16)
                    }
                    else {
                        Text(previewComponentParam.joinButtonLabel)
                            .font(.buttonSemibold16)
                    }
                }
            }
        }
        .foreground(userName.isEmpty ? .onPrimaryLow : .onPrimaryHigh)
        .padding()
        .frame(minWidth: 103, minHeight: 48)
        .background(userName.isEmpty ? .primaryDisabled : .primaryDefault, cornerRadius: 8)
    }
}

struct HMSJoinButtonView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HMSJoinLabelView(userName: "Pawan iOS", isJoining: .constant(false))
                .environmentObject(HMSUITheme())
            
            HMSJoinLabelView(userName: "Pawan iOS", isJoining: .constant(true))
                .environmentObject(HMSUITheme())
            
            HMSJoinLabelView(userName: "Pawan iOS", isJoining: .constant(false))
                .environmentObject(HMSUITheme())
                .environment(\.previewComponentParam, HMSPreviewScreen.DefaultType(title: "Go Live", subTitle: "defaultValue", joinButtonType: .goLive, joinButtonLabel: "defaultValue", goLiveButtonLabel: "defaultGoLive"))
        }
    }
}
