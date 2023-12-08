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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Spacer(minLength: 24)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("", systemImage: "chevron.left").foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                }
                Text(model.poll.category == .poll ? "Poll" : "Quiz").foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().heading6Semibold20)
                PollStateBadgeView(pollState: model.poll.state)
                Spacer().frame(height: 16)
            }
            Spacer(minLength: 16)
            PollDivider()
            Spacer(minLength: 24)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Leaderboard").foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().subtitle2Semibold14)
                            Text("Based on time taken to cast the correct answer").foregroundColor(HMSUIColorTheme().onSurfaceMedium).font(HMSUIFontTheme().captionRegular)
                        }
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(model.entries) { entry in
                            PollLeaderboardEntryView(model: entry)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .background(HMSUIColorTheme().surfaceDim)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onAppear {
            model.fetchLeaderboard()
        }
        
    }
}

struct PollLeaderboardEntryView: View {
    var model: PollLeaderboardEntryViewModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if model.place < 4 {
                Text("\(model.place)").foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().captionSemibold12).padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                    .background(
                        Rectangle()
                            .cornerRadius(12, corners: .allCorners)
                            .foregroundColor(placeColor(for: model.place))
                            .frame(width: 24, height: 24)
                    ).frame(width: 24, height: 24)
            } else {
                Text("\(model.place)").foregroundColor(HMSUIColorTheme().onSurfaceLow).font(HMSUIFontTheme().captionSemibold12)
            }
            
            VStack(alignment: .leading) {
                Text(model.name).foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().subtitle2Semibold14)
                if !model.score.isEmpty {
                    Text(model.score).foregroundColor(HMSUIColorTheme().onSurfaceMedium).font(HMSUIFontTheme().captionRegular)
                }
            }
            Spacer()
            if model.place == 1 {
                Image(assetName: "prize", renderingMode: .original)
            }
            HStack(spacing: 4) {
                Image(assetName: "circle-checkmark").foregroundColor(HMSUIColorTheme().onSurfaceMedium).frame(width: 12, height: 12)
                Text(model.correctAnswers).foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().captionRegular)
            }
            if !model.time.isEmpty {
                HStack(spacing: 4) {
                    Image(assetName: "clock").foregroundColor(HMSUIColorTheme().onSurfaceMedium).frame(width: 12, height: 12)
                    Text(model.time).foregroundColor(HMSUIColorTheme().onSurfaceHigh).font(HMSUIFontTheme().captionRegular)
                }
            }
        }
    }
    
    func placeColor(for place: Int) -> Color {
        switch place {
        case 1:
            return Color(red: 0.84, green: 0.58, blue: 0.09)
        case 2:
            return Color(red: 0.24, green: 0.24, blue: 0.24)
        case 3:
            return Color(red: 0.35, green: 0.23, blue: 0.06)
        default:
            break
        }
        
        return .clear
    }        
}
