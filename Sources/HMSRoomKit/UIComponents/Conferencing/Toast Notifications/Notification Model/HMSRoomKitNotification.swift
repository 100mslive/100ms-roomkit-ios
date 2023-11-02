//
//  HMSRoomKitNotification.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation

struct HMSRoomKitNotification: Identifiable, Hashable {
    
    enum `Type`: Hashable, Equatable {
        case raiseHand
        case declineRoleChange
        case groupedDeclineRoleChange(ids: [String])
        case groupedRaiseHand(ids: [String])
        case error(icon: String, retry: Bool, isTerminal: Bool)
        case info(icon: String)
        case screenShare
    }
    
    enum Action: Hashable {
        case none
        case bringOnStage
        case viewBringOnStageParticipants
        case retry
        case endCall
        case stopScreenShare
    }
    
    let id: String
    let type: `Type`
    let actorName: String
    var isDismissed = false
    var title: String
    let isDismissable: Bool
    
    var action: Action {
        switch type {
        case .raiseHand:
            return Action.bringOnStage
        case .declineRoleChange:
            return  Action.none
        case .groupedRaiseHand(_):
            return  Action.viewBringOnStageParticipants
        case .error(icon: _, retry: let retry, isTerminal: let isTerminal):
            return isTerminal ? .endCall : retry ? Action.retry : Action.none
        case .info(icon: _):
            return .none
        case .screenShare:
            return .stopScreenShare
        case .groupedDeclineRoleChange(_):
            return .none
        }
    }
}
