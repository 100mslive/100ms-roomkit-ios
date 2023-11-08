//
//  HMSPollModel.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 11/1/23.
//

import SwiftUI
import HMSRoomModels
import HMSSDK

class HMSRoomKitPollModel: ObservableObject {
    
    @Published var currentPolls = Set<HMSPoll>()
    
    weak var roomModel: HMSRoomModel?
    
    func beginListeningForPolls() {
        (roomModel?.interactivityCenter.polls ?? []).forEach { poll in
            self.currentPolls.insert(poll)
        }
        roomModel?.interactivityCenter.addPollUpdateListner { [weak self] poll, update in
            guard let self else { return }
            switch update {
            case .started:
                self.currentPolls.insert(poll)
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
