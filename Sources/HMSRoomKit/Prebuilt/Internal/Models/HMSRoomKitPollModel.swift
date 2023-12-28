//
//  HMSPollModel.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 11/1/23.
//

import SwiftUI
import HMSRoomModels
import HMSSDK

extension HMSPoll {
    public override var hash: Int {
        return pollID.hashValue
    }
    public override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? HMSPoll {
            return pollID == other.pollID
        }
        return false
    }
}

class HMSRoomKitPollModel: ObservableObject {
    
    @Published var currentPolls = Set<HMSPoll>()
    @Published var polls = Set<HMSPoll>()
    
    weak var roomModel: HMSRoomModel?
    
    func beginListeningForPolls() {
        
        currentPolls.removeAll()
        
        (roomModel?.interactivityCenter.polls ?? []).forEach { poll in
            self.currentPolls.update(with: poll)
        }
        
        roomModel?.interactivityCenter.addPollUpdateListner { [weak self] poll, update in
            guard let self else { return }
            switch update {
            case .started:
                self.currentPolls.update(with: poll)
                self.polls.update(with: poll)
            case .resultsUpdated:
                break
            case .stopped:
                self.currentPolls.remove(poll)
            @unknown default:
                break
            }
        }
    }
}
