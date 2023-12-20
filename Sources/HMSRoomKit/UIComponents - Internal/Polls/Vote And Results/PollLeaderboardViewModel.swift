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
    var isAmdin = false
    var userID: String = ""
    
    @Published var isFetching = false
    @Published var hasNext = true
    @Published var entries = [PollLeaderboardEntryViewModel]()
    @Published var summaryEntries = [PollLeaderboardEntryViewModel]()
    @Published var summary: PollSummaryViewModel?
    
    
    internal init(poll: HMSPoll, interactivityCenter: HMSInteractivityCenter, isAmdin: Bool) {
        self.poll = poll
        self.interactivityCenter = interactivityCenter
        self.isAmdin = isAmdin
    }
    
    func fetchLeaderboardSummary(userID: String) {
        self.userID = userID
        
        guard summary == nil else { return }
        isFetching = true
        interactivityCenter.fetchLeaderboard(for: poll, offset: 0, count: 5, includeCurrentPeer: !isAmdin) { [weak self] response, error in
            guard let self = self else { return }
            self.isFetching = false
            if let response = response {
                let newEntries = response.entries.map { PollLeaderboardEntryViewModel(entry: $0, poll: self.poll) }
                self.summaryEntries = newEntries
                self.setupSummary(with: response)
            }
        }
    }
    
    func fetchLeaderboard() {
        guard hasNext else { return }
        isFetching = true
        let currentOffset = entries.count
        interactivityCenter.fetchLeaderboard(for: poll, offset: currentOffset + 1, count: 50) { [weak self] response, error in
            guard let self = self else { return }
            self.isFetching = false
            if let response = response {
                let newEntries = response.entries.map { PollLeaderboardEntryViewModel(entry: $0, poll: self.poll) }
                self.entries.append(contentsOf: newEntries)
                self.hasNext = response.hasNext
            }
        }
    }
    
    func setupSummary(with response: HMSPollLeaderboardResponse) {
        isAmdin ? setupAdminSummary(with: response) : setupUserSummary(with: response)
    }
    
    func setupAdminSummary(with response: HMSPollLeaderboardResponse) {
        let summary = response.summary
        
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
    
    func setupUserSummary(with response: HMSPollLeaderboardResponse) {
        let summary = response.summary
        guard summary.totalPeersCount > 0 else { return }
        
        guard let userEntry = response.entries.first(where: { $0.peer?.customerUserID == userID }) else { return }
        let model = PollLeaderboardEntryViewModel(entry: userEntry, poll: poll)
        
        let rank = PollSummaryItemViewModel(title: "YOUR RANK", subtitle: "(\(model.place)/\(summary.totalPeersCount)")
        
        let points = PollSummaryItemViewModel(title: "POINTS", subtitle: "\(userEntry.score)")
        let row1 = PollSummaryItemRowViewModel(items: [rank, points])
        
        let time = PollSummaryItemViewModel(title: "TIME TAKEN", subtitle: model.time)
        let score = PollSummaryItemViewModel(title: "CORRECT ANSWERS", subtitle: model.correctAnswers)
        let row2 = PollSummaryItemRowViewModel(items: [time, score])
        
        self.summary = PollSummaryViewModel(items: [row1, row2])
    }
}

class PollLeaderboardEntryViewModel: Identifiable {
    internal init(entry: HMSPollLeaderboardEntry, poll: HMSPoll) {
        let questions = poll.questions ?? []
        let totalQuestions = questions.count
        let totalScore = questions.reduce(0) { partialResult, question in
            partialResult + question.weight
        }
        
        self.place = entry.position
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
