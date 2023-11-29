//
//  PollResultsView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 29.11.2023.
//

import SwiftUI

struct PollResultsView: View {
    @ObservedObject var model: PollLeaderboardViewModel
    
    var body: some View {
        VStack {
            PollLeaderboardView(model: model)
        }
    }
}

