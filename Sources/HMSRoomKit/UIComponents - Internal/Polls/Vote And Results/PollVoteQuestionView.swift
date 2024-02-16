//
//  PollVoteQuestionView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct PollVoteQuestionView: View {
    @ObservedObject var model: PollVoteQuestionViewModel
    var onVote: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("QUESTION \(model.index) of \(model.count)").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().captionRegular12)
            
            HStack{
                Text(model.text).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body1Regular16)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 16) {
                if model.poll.category == .poll || model.canVote || model.poll.state == .started {
                    ForEach(model.questionOptions) { option in
                        PollVoteQuestionOptionView(model: option)
                    }
                } else {
                    ForEach(model.questionOptions) { option in
                        QuizVoteQuestionOptionView(model: option)
                    }
                }
            }
            
            HStack(spacing: 8) {
                Spacer()
                if model.canVote {
                    Button {
                        onVote()
                    } label: {
                        Text(model.poll.category == .poll ? "Vote" : "Answer")
                    }.buttonStyle(ActionButtonStyle(isWide: false, isDisabled: !model.answerSelected)).disabled(!model.answerSelected)
                } else if model.poll.state == .started {
                    Text(model.poll.category == .poll ? "Voted" : "Answered").foregroundColor(HMSUIColorTheme().onSurfaceLow).font(HMSUIFontTheme().buttonSemibold16)
                }
            }
             
        }.padding(16).background(HMSUIColorTheme().surfaceDefault).overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(model.borderColor, lineWidth: 1)).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}


struct PollVoteQuestionCarouselView: View {
    var questions: [PollVoteQuestionViewModel]
    @State var questionIndex = 0
    @State var startDate = Date()
    
    var body: some View {
        let model = questions[questionIndex]
        
        PollVoteQuestionView(model: model, onVote: {
            if questionIndex + 1 < questions.count {
                questionIndex += 1
            }
            let interval = Date().timeIntervalSince(startDate)
            model.vote(duration: interval)
            startDate = Date()
        })
        .onAppear {
            questionIndex = questions.firstIndex(where: { $0.canVote == true }) ?? (questions.count - 1)
        }
    }
}



