//
//  HMSStopRecordingView.swift
//  HMSSDK
//
//  Created by Dmitry Fedoseyev on 14.08.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
#if !Preview
import HMSSDK
#endif


struct HMSStopRecordingView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(assetName: "warning-icon-large")
                Text("Stop Recording")
                    .font(.heading6Semibold20)
                    .foreground(.errorDefault)
                Spacer()
                Image(assetName: "close")
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            Text("Are you sure you want to stop recording? You can’t undo this action.").fixedSize(horizontal: false, vertical: true).font(.body2Regular14).foreground(.onSurfaceMedium)
            Spacer().frame(height: 8)
            Text("Stop").font(.buttonSemibold16).foreground(.errorBrighter).frame(maxWidth: .infinity).padding(.vertical, 12).background(.errorDefault, cornerRadius: 8).onTapGesture {
                Task {
                    try await roomModel.stopRecording()
                }
                presentationMode.wrappedValue.dismiss()
            }
        }.padding(24)
        
    }
}

struct HMSStopRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        HMSStopRecordingView().environmentObject(HMSUITheme())
    }
}
