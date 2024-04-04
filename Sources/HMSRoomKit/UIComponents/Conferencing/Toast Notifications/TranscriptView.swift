//
//  HMSTranscriptView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 4/2/24.
//

import SwiftUI
import HMSRoomModels

struct HMSTranscriptView: View {

    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
            VStack {
                Text(roomModel.transcript.suffix(400))
                    .lineLimit(nil)
                    .foregroundStyle(.white)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: 88, alignment: .bottom)
            .fixedSize(horizontal: false, vertical: true)
            .clipped()
            .padding(30)
    }
}

struct HMSTranscriptView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSTranscriptView()
            .environmentObject(HMSRoomModel.dummyRoom(2))
#endif
    }
}
