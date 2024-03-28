//
//  WhiteboardView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 3/19/24.
//

import SwiftUI

struct HMSWhiteboardView: View {
    
    let url: URL
    
    var body: some View {
        WebView(url: url)
            .onTapGesture {
                // disable tap gesture
            }
    }
}

struct HMSWhiteboardView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSWhiteboardView(url: URL(string: "https://google.com")!)
#endif
    }
}
