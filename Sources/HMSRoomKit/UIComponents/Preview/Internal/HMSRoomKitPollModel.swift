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
    
    @Published var currentPolls = [HMSPoll]()
    
    weak var roomModel: HMSRoomModel?
    
    func beginListeningForPolls() {
        roomModel?.interactivityCenter.addPollUpdateListner { [weak self] poll, update in
            guard let self else { return }
            switch update {
            case .started:
                self.currentPolls.append(poll)
            case .resultsUpdated:
                break
            case .stopped:
                self.currentPolls.removeAll{$0.pollID == poll.pollID}
            @unknown default:
                break
            }
        }
    }
}
