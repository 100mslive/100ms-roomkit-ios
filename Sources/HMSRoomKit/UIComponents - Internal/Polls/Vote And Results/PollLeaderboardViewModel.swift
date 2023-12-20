//
//  PollLeaderboardViewModel.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 28.11.2023.
//

import Foundation
import HMSSDK

class PollLeaderboardViewModel: ObservableObject, Identifiable {
    let interactivityCenter: HMSInteractivityCenter
    var poll: HMSPoll
    
    @Published var isFetching = false
    @Published var hasNext = true
    @Published var entries = [PollLeaderboardEntryViewModel]()
    @Published var summary: PollSummaryViewModel?
    
    
    internal init(poll: HMSPoll, interactivityCenter: HMSInteractivityCenter) {
        self.poll = poll
        self.interactivityCenter = interactivityCenter
    }
    
    func fetchLeaderboard() {
        guard hasNext else { return }
        isFetching = true
        let currentOffset = entries.count
        interactivityCenter.fetchLeaderboard(for: poll, offset: currentOffset + 1, count: 50) { [weak self] response, error in
            guard let self = self else { return }
            self.isFetching = false
            if let response = response {
                let newEntries = response.entries.enumerated().map { PollLeaderboardEntryViewModel(entry: $1, poll: self.poll, place: currentOffset + $0 + 1) }
                self.entries.append(contentsOf: newEntries)
                self.hasNext = response.hasNext
                self.setupSummary(with: response.summary)
            }
        }
    }
    
    func setupSummary(with summary: HMSPollLeaderboardSummary) {
        guard summary.totalPeersCount > 0 else { return }
        
        let votedPercent = summary.respondedPeersCount * 100 / summary.totalPeersCount
        let votedDescription = "(\(summary.respondedPeersCount)/\(summary.totalPeersCount)"
        let voted = PollSummaryItemViewModel(title: "VOTED", subtitle: "\(votedPercent)% \(votedDescription))")
        
        let correctPercent = summary.respondedCorrectlyPeersCount * 100 / summary.totalPeersCount
        let correctDescription = "(\(summary.respondedCorrectlyPeersCount)/\(summary.totalPeersCount)"
        let correct = PollSummaryItemViewModel(title: "CORRECT ANSWERS", subtitle: "\(correctPercent)% \(correctDescription))")
        let row1 = PollSummaryItemRowViewModel(items: [voted, correct])
        
        let avgTime = PollSummaryItemViewModel(title: "AVG. TIME TAKEN", subtitle: "\(summary.averageTime)")
        let avgScore = PollSummaryItemViewModel(title: "AVG. SCORE", subtitle: "\(summary.averageScore)")
        let row2 = PollSummaryItemRowViewModel(items: [avgTime, avgScore])
        
        self.summary = PollSummaryViewModel(items: [row1, row2])
    }
}

class PollLeaderboardEntryViewModel: Identifiable {
    internal init(entry: HMSPollLeaderboardEntry, poll: HMSPoll, place: Int) {
        let questions = poll.questions ?? []
        let totalQuestions = questions.count
        let totalScore = questions.reduce(0) { partialResult, question in
            partialResult + question.weight
        }
        
        self.place = place
        self.name = entry.peer?.userName ?? "Unknown"
        self.score = totalScore > 0 ? "\(entry.score)/\(totalScore)" : ""
        self.correctAnswers = "\(entry.correctResponses)/\(totalQuestions)"
        self.time = ""
        self.isNoResponse = entry.totalResponses == 0
    }
    
    var id: Int {
        place
    }
    
    let place: Int
    let name: String
    let score: String
    let correctAnswers: String
    let time: String
    let isNoResponse: Bool
}
