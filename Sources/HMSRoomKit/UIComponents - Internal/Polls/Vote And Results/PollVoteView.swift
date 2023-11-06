//
//  PollVoteView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 25.05.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

struct PollVoteView: View {
    internal init(model: PollVoteViewModel) {
        self.model = model
    }
    
    @ObservedObject var model: PollVoteViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer(minLength: 24)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("", systemImage: "chevron.left").foregroundColor(HMSUIColorTheme().onPrimaryHigh)
                }
                Text(model.poll.category == .poll ? "Poll" : "Quiz").foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().heading6Semibold20)
                PollStateBadgeView(pollState: model.poll.state, endDate: model.endDate)
                Spacer().frame(height: 16)
            }
            Spacer(minLength: 16)
            PollDivider()
            Spacer(minLength: 24)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if !model.startedByName.isEmpty {
                        Text("\(model.startedByName) started a \(model.poll.category == .poll ? "poll" : "quiz")").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().subtitle1)
                    }
                    if let summary = model.summary {
                        Text("Participation Summary").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().subtitle2Semibold14)
                        PollSummaryView(model: summary).padding(.bottom, 8)
                        Text("Questions").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().subtitle2Semibold14)
                    }
                    ForEach(model.questions) { question in
                        PollVoteQuestionView(model: question)
                    }
                    
                    if model.canEndPoll {
                        HStack {
                            Spacer()
                            Button {
                                model.endPoll() {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                Text("End \(model.poll.category == .poll ? "Poll" : "Quiz")")
                            }.buttonStyle(ActionButtonStyle(isWide: false))
                        }
                    }
                }
            }.background(HMSUIColorTheme().surfaceDefault)
        }.padding(.horizontal, 24).background(HMSUIColorTheme().surfaceDefault).onAppear(perform: model.load).ignoresSafeArea().navigationBarHidden(true)
    }
}
