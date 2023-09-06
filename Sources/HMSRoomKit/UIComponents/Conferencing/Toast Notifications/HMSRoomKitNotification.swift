//
//  HMSRoomKitNotification.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import Foundation

@MainActor
extension HMSRoomKitModel {
    var raisedHandNotifications: [HMSRoomKitNotification] {
        notifications.filter{$0.type == .raiseHand}
    }
    
    var activeNotifications: [HMSRoomKitNotification] {
        notifications.filter{!$0.isDismissed}
    }
    
    func addNotification(_ notification: HMSRoomKitNotification) {
        let roomKitModel = self
        
        if let index = roomKitModel.notifications.firstIndex(where: {$0.id == notification.id}) {
            
            // if user had dismissed it, show it again
            if roomKitModel.notifications[index].isDismissed {
                roomKitModel.notifications[index].title = notification.title
                roomKitModel.notifications[index].isDismissed = false
            }
            else {
                // do nothing
            }
        }
        else {
            roomKitModel.notifications.append(notification)
        }
    }
    
    func removeNotification(for ids: [String]) {
        notifications.removeAll{ids.contains($0.id)}
    }
    
    func removeNotifications(of type: HMSRoomKitNotification.`Type`) {
        notifications.removeAll{$0.type == type}
    }
    
    func dismissNotification(for id: String) {
        let roomKitModel = self
        
        if let index = roomKitModel.notifications.firstIndex(where: {$0.id == id}) {
            roomKitModel.notifications[index].isDismissed = true
        }
    }
}

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
    
    var id: String {
        identity
    }
    
    let identity: String
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
