//
//  PollLeaderboardView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 28.11.2023.
//

import SwiftUI
import HMSSDK

struct PollLeaderboardView: View {
    @ObservedObject var model: PollLeaderboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Leaderboard").foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().subtitle2Semibold14)
                Text("Based on time taken to cast the correct answer").foregroundColor(HMSUIColorTheme().onSurfaceMedium).font(HMSUIFontTheme().captionRegular)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(model.entries) { entry in
                    PollLeaderboardEntryView(model: entry)
                }
            }
        }.padding(16).background(HMSUIColorTheme().surfaceBright)
            .onAppear {
                model.fetchLeaderboard()
            }
    }
}

struct PollLeaderboardEntryView: View {
    var model: PollLeaderboardEntryViewModel
    
    var body: some View {
        HStack {
            Text("\(model.place)")
            VStack {
                Text(model.name)
                Text(model.score)
            }
            Text(model.correctAnswers)
            Text(model.time)
        }
    }
        
}
