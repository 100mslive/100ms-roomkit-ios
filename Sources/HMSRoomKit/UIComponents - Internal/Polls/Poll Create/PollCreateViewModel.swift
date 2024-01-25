//
//  PollCreateViewModel.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation
import HMSSDK

class PollCreateModel: ObservableObject, Identifiable {
    let interactivityCenter: HMSInteractivityCenter
    
    @Published var selectedCategory: HMSPollCategory = .poll
    @Published var pollTitle: String = ""
    @Published var hideVotes: Bool = false
    @Published var anonymous: Bool = false
    @Published var enableTimer: Bool = false
    @Published var isShowingQuestionView: Bool = false
    @Published var valid: Bool = true
    @Published var errorMessage: String = ""

    @Published var selectedTimerDuration: String = "5 minutes"
    @Published var timerDurationOptions: [String] = ["5 minutes", "15 minutes", "30 minutes", "1 hour"]
    
    var currentPollsSet = Set<PollListModel>()
    @Published var currentPolls = [PollListModel]()

    var durations = [5, 15, 30, 60]
    
    var createdPoll: HMSPoll?
    
    var limitViewResultsToRoles: [HMSRole]
    var currentRole: HMSRole
    
    var onPollStart: (()->Void)?
    
    var canCreatePolls: Bool

    lazy var questionModel: QuestionCreateViewModel = {
        QuestionCreateViewModel(pollModel: PollCreateModel(interactivityCenter: interactivityCenter, currentRole: currentRole))
    }()
    
    internal init(interactivityCenter: HMSInteractivityCenter, limitViewResultsToRoles: [HMSRole] = [], currentRole: HMSRole) {
        self.interactivityCenter = interactivityCenter
        self.limitViewResultsToRoles = limitViewResultsToRoles
        self.currentRole = currentRole
        self.canCreatePolls = self.currentRole.permissions.pollWrite ?? false
        setupObserver()
    }

    func timerDuration() -> Int {
        let index = timerDurationOptions.firstIndex(of: selectedTimerDuration) ?? 0
        return durations[index]
    }
    
    func validate() -> Bool {
        if pollTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            valid = false
            errorMessage = "Please fill in the name field to Start."
        } else {
            valid = true
            errorMessage = ""
        }
        
        return valid
    }
    
    func createPoll() {
        guard validate() else { return }
        
        let poll = HMSPollBuilder()
            .withTitle(pollTitle.trimmingCharacters(in: .whitespacesAndNewlines))
            .withAnonymous(anonymous)
            .withRolesThatCanViewResponses(hideVotes ? limitViewResultsToRoles : [])
            .withDuration(enableTimer ? timerDuration() * 60 : 0)
            .withCategory(selectedCategory).build()

        createdPoll = poll
        questionModel.pollModel.createdPoll = createdPoll
        questionModel.pollModel.onPollStart = onPollStart
        questionModel.questions = [QuestionCreateModel]()
        
        interactivityCenter.create(poll: poll) { [weak self] success, error in
            if nil == error {
                self?.refreshLocalPolls()
                self?.isShowingQuestionView = true
                self?.pollTitle = ""
            } else {
                self?.createdPoll = nil
            }
        }
    }

    func startPoll() {
        guard let createdPoll = createdPoll else { return }
        interactivityCenter.start(poll: createdPoll) { [weak self] success, error in
            self?.onPollStart?()
        }
    }
    
    func createModel(poll: HMSPoll) -> PollCreateModel? {
        guard poll.state == .created else { return nil }
        let model = PollCreateModel(interactivityCenter: interactivityCenter, limitViewResultsToRoles: limitViewResultsToRoles, currentRole: currentRole)
        model.createdPoll = poll
        model.onPollStart = onPollStart
        return model
    }
    
    func resultModel(poll: HMSPoll) -> PollVoteViewModel? {
        guard poll.state == .started || poll.state == .stopped else { return nil }
        let model = PollVoteViewModel(poll: poll, interactivityCenter: interactivityCenter, currentRole: currentRole, peerList: [])
        model.canEndPoll = canCreatePolls && poll.state == .started
        model.isAdmin = canCreatePolls
        return model
    }
    
    func refreshLocalPolls() {
        let allPolls = interactivityCenter.polls.map { PollListModel(poll: $0, resultModel: self.resultModel(poll: $0), createModel: self.createModel(poll: $0)) }
        
        currentPollsSet.formUnion(allPolls)
        
        currentPollsSet.forEach { $0.updateValues() }
        
        let stateOrder = [HMSPollState.started, HMSPollState.created, HMSPollState.stopped]
        currentPolls = currentPollsSet.sorted { left, right in
                if left.state != right.state {
                    let leftIndex = stateOrder.firstIndex(of: left.state) ?? 0
                    let rightIndex = stateOrder.firstIndex(of: right.state) ?? 0
                    return leftIndex < rightIndex
                } else if left.state == .started, let leftDate = left.poll.startedAt, let rightDate = right.poll.startedAt {
                    return leftDate > rightDate
                } else if left.state == .stopped, let leftDate = left.poll.stoppedAt, let rightDate = right.poll.stoppedAt {
                    return leftDate > rightDate
                }
                
                return false
            }
    }
    
    func refreshPolls() {
        refreshLocalPolls()
        
        interactivityCenter.fetchPollList(state: .created) { [weak self] polls, error in
            guard let self = self else { return }
            self.refreshLocalPolls()
            interactivityCenter.fetchPollList(state: .stopped) { [weak self] polls, error in
                guard let self = self else { return }
                self.refreshLocalPolls()
            }
        }
    }
    
    func setupObserver() {
        interactivityCenter.addPollUpdateListner { [weak self] updatedPoll, update in
            guard let self = self else { return }
            switch update {
            case .started, .stopped:
                self.refreshPolls()
            default:
                break
            }
        }
    }
}

