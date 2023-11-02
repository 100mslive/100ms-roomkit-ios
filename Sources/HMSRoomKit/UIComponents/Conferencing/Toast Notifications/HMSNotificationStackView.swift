//
//  HMSNotificationStackView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSNotificationStackView: View {
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomKitModel: HMSRoomKitModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @State var isHandRaisedSheetPresented = false
    
    var body: some View {
        
        let onStageExperience = conferenceComponentParam.onStageExperience
        let onStageRole = onStageExperience?.onStageRoleName ?? ""
        
        let handRaisedNotifications = Set(roomKitModel.activeNotifications.filter{$0.type == .raiseHand})
        let declineRoleChangeNotifications = Set(roomKitModel.activeNotifications.filter{$0.type == .declineRoleChange})
        
        let groupedNotifications: [HMSRoomKitNotification] = {
            
            if handRaisedNotifications.count > 1 {
                let combinedHandRaisedNotification = HMSRoomKitNotification(id: handRaisedNotifications.map{$0.id}.joined(separator: "+"), type: .groupedRaiseHand(ids: handRaisedNotifications.map{$0.id}), actor: handRaisedNotifications.map{$0.actor}.joined(separator: ", "), isDismissible: true, title: "\(handRaisedNotifications.first?.actor ?? "") and \(handRaisedNotifications.count - 1) other\(handRaisedNotifications.count > 2 ? "s" : "") raised hand")
                
                if let lastRaisedHandIndex = roomKitModel.activeNotifications.lastIndex(where: {$0.type == .raiseHand}) {
                    return (roomKitModel.activeNotifications[0..<lastRaisedHandIndex] +  [combinedHandRaisedNotification] + roomKitModel.activeNotifications[(lastRaisedHandIndex + 1)..<roomKitModel.activeNotifications.count]).filter{$0.type != .raiseHand}
                }
            }
            
            if declineRoleChangeNotifications.count > 1 {
                let combinedDeclineRoleChangeNotification = HMSRoomKitNotification(id: declineRoleChangeNotifications.map{$0.id}.joined(separator: "+"), type: .groupedDeclineRoleChange(ids: declineRoleChangeNotifications.map{$0.id}), actor: declineRoleChangeNotifications.map{$0.actor}.joined(separator: ", "), isDismissible: true, title: "\(declineRoleChangeNotifications.first?.actor ?? "") and \(declineRoleChangeNotifications.count - 1) other\(declineRoleChangeNotifications.count > 2 ? "s" : "") declined the request to join the stage")
                
                if let lastDeclineRoleChangeNotificationIndex = roomKitModel.activeNotifications.lastIndex(where: {$0.type == .declineRoleChange}) {
                    return (roomKitModel.activeNotifications[0..<lastDeclineRoleChangeNotificationIndex] +  [combinedDeclineRoleChangeNotification] + roomKitModel.activeNotifications[(lastDeclineRoleChangeNotificationIndex + 1)..<roomKitModel.activeNotifications.count]).filter{$0.type != .declineRoleChange}
                }
            }
            
            return roomKitModel.activeNotifications
        }()
        
        if groupedNotifications.count > 0 {
            VStack(spacing: 8) {
                ForEach(roomModel.isUserJoined ? groupedNotifications.prefix(3) : groupedNotifications.filter {
                    if case .error(_,_,_) = $0.type {
                        return true
                    }
                    else {
                        return false
                    }
                }.suffix(3)) { notification in
                    HMSNotificationView(notification: notification) {
                        // Dismiss
                        withAnimation {
                            switch notification.type {
                            case .groupedRaiseHand(let ids):
                                ids.forEach {roomKitModel.dismissNotification(for: $0)}
                            case .groupedDeclineRoleChange(let ids):
                                ids.forEach {roomKitModel.dismissNotification(for: $0)}
                            default:
                                roomKitModel.dismissNotification(for: notification.id)
                            }
                        }
                    } onAction: {
                        switch notification.action {
                        case .none:
                            break
                        case .bringOnStage:
                            guard !onStageRole.isEmpty else { return }
                            Task {
                                guard let peerModel = roomModel.peerModels.first(where: { $0.id == notification.id }) else { return }
                                try await roomModel.changeRole(of: peerModel, to: onStageRole)
                            }
                            roomKitModel.dismissNotification(for: notification.id)
                            break
                        case .viewBringOnStageParticipants:
                            isHandRaisedSheetPresented.toggle()
                        case .retry:
                            if notification.id == "RecordingFailed" {
                                Task {
                                    try await roomModel.startRecording()
                                }
                            }
                            break
                        case .stopScreenShare:
                            // Button already can stop screen share. do nothing
                            break
                        case .endCall:
                            Task {
                                try await roomModel.leaveSession()
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isHandRaisedSheetPresented) {
                Group {
                    if #available(iOS 16.0, *) {
                        HMSChatParticipantToggleView(initialPane: .participants).presentationDetents([.large])
                    } else {
                        HMSChatParticipantToggleView(initialPane: .participants)
                    }
                }
                .environmentObject(currentTheme)
                .environmentObject(roomModel)
            }
        }
    }
}

struct HMSNotificationStackView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        let model: HMSRoomKitModel = {
            let model = HMSRoomKitModel()
            model.notifications.append(.init(id: "id1", type: .raiseHand, actor: "Pawan", isDismissible: true, title: "Peer1 raised hands Peer1 raised hands"))
            model.notifications.append(.init(id: "id2", type: .raiseHand, actor: "Dmitry", isDismissible: true, title: "Peer2", isDismissed: true))
            model.notifications.append(.init(id: "id3", type: .raiseHand, actor: "Praveen", isDismissible: true, title: "Peer3 raised hands"))
            model.notifications.append(.init(id: "id4", type: .raiseHand, actor: "Bajaj", isDismissible: true, title: "Peer4 raised hands"))
            model.notifications.append(.init(id: "id5", type: .declineRoleChange, actor: "Bajaj", isDismissible: true, title: "Peer5 declined request"))
            return model
        }()
        
        HMSNotificationStackView()
            .environmentObject(model)
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
            .environmentObject(HMSRoomInfoModel())
#endif
    }
}

