//
//  ContentView.swift
//  HMSRoomKitExample
//
//  Created by Pawan Dixit on 06/09/2023.
//

import SwiftUI
import HMSRoomKit

struct ContentView: View {
    @State var isMeetingViewPresented = false
    @State var roomCode = ""
    
    var body: some View {
        if isMeetingViewPresented && !roomCode.isEmpty {
            HMSPrebuiltView(roomCode: roomCode, onDismiss: {
                isMeetingViewPresented = false
            })
        }
        else {
            JoiningView(roomCode: $roomCode, isMeetingViewPresented: $isMeetingViewPresented)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
