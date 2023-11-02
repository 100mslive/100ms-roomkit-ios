//
//  File.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 11/2/23.
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
