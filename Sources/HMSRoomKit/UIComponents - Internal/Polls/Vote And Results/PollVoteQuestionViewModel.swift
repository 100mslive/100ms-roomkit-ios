//
//  PollVoteQuestionViewModel.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class PollVoteQuestionViewModel: ObservableObject, Identifiable {
    @Published var text: String = ""
    @Published var questionOptions = [PollVoteQuestionOptionViewModel]()
    @Published var index: Int = 1
    @Published var count: Int = 1
    @Published var canVote: Bool = false {
        didSet {
            updateValues()
            updateResults()
        }
    }
    @Published var canSkip: Bool = false
    @Published var answerSelected: Bool = false
    @Published var borderColor = HMSUIColorTheme().surfaceBright
    
    var poll: HMSPoll
    var onVote: ((PollVoteQuestionViewModel) -> Void)
    var question: HMSPollQuestion {
        didSet {
           updateValues()
        }
    }
    var canViewResponses: Bool
    var duration: TimeInterval = 0
    
    internal init(question: HMSPollQuestion, count: Int, poll: HMSPoll, canVote: Bool, canViewResponses: Bool, onVote: @escaping ((PollVoteQuestionViewModel) -> Void)) {
        self.question = question
        self.count = count
        self.onVote = onVote
        self.poll = poll
        self.canVote = canVote
        self.canViewResponses = canViewResponses
        updateValues()
        updateResults()
    }
    
    func vote(duration: TimeInterval = 0) {
        self.duration = duration
        
        for (index, option) in questionOptions.enumerated() {
            if (option.selected) {
                question.options?[index].voteCount += 1
            }
        }
        
        onVote(self)
    }
    
    func updateValues() {
        text = question.text
        index = question.index
        let selection: ((PollVoteQuestionOptionViewModel)->Void) = { [weak self] selectedModel in
            guard let options = self?.questionOptions else { return }
            
            var hasSelections = false
            for optionModel in options {
                if optionModel.selected {
                    hasSelections = true
                }
                
                guard selectedModel.isSingleChoice else { continue }

                optionModel.selected = optionModel.option.index == selectedModel.option.index
            }
            
            self?.answerSelected = hasSelections
        }
        
        let singleChoice = question.type == .singleChoice
        let selectedIndexes = canVote ? Set<Int>() : question.selectedOptionIndexes
        let correctIndexes = canVote ? Set<Int>() : question.correctOptionIndexes
        
        if poll.category == .quiz, question.voted, poll.state == .stopped {
            let correct = selectedIndexes == correctIndexes
            borderColor = correct ? HMSUIColorTheme().alertSuccess : HMSUIColorTheme().alertErrorDefault
        } else {
            borderColor = HMSUIColorTheme().surfaceBright
        }
        
        questionOptions = question.options?.map { PollVoteQuestionOptionViewModel(option: $0, isSingleChoice: singleChoice, canVote: canVote, selected: selectedIndexes.contains($0.index), isCorrect: poll.state == .stopped && correctIndexes.contains($0.index), canViewResponses: canViewResponses, onSelectionChange: selection) } ?? []
    }
    
    func updateResults() {
        guard let options = question.options else { return }

        guard questionOptions.count == options.count else {
            return
        }
        
        var totalVotes = 0
        for option in options {
            totalVotes += option.voteCount
        }
        
        for (index, questionOption) in questionOptions.enumerated() {
            guard let voteCount = question.options?[index].voteCount else { continue }
            questionOption.voteCount = voteCount
            questionOption.totalCount = totalVotes
        }
    }
}
