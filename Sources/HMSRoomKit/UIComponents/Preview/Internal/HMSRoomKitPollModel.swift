//
//  HMSPollModel.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 11/1/23.
//

import SwiftUI
import HMSRoomModels

class HMSRoomKitPollModel: ObservableObject {
    
    @Published var isPollViewHidden = true
    
    weak var roomModel: HMSRoomModel?
    
    func beginListeningForPolls() {
        roomModel?.interactivityCenter.addPollUpdateListner { [weak self] poll, update in
            
            switch update {
            case .started:
                let hasLivePolls = self?.roomModel?.interactivityCenter.polls.first(where: { $0.state == .started }) != nil
                self?.isPollViewHidden = !hasLivePolls
            case .resultsUpdated:
//                                    self?.onPollResults?(poll)
                break
            case .stopped:
                let hasLivePolls = self?.roomModel?.interactivityCenter.polls.first(where: { $0.state == .started }) != nil
                self?.isPollViewHidden = !hasLivePolls
            @unknown default:
                break
            }
        }
    }
}
