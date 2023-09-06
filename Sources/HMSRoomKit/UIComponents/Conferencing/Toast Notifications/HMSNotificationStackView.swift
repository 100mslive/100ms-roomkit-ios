//
//  HMSNotificationStackView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 28/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

struct HMSNotificationStackView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var roomKitModel: HMSRoomKitModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomInfoModel: HMSRoomInfoModel
    
    @State var isHandRaisedSheetPresented = false
    
    var body: some View {
        
        let handRaisedNotifications = roomKitModel.activeNotifications.filter{$0.type == .raiseHand}
        let declineRoleChangeNotifications = roomKitModel.activeNotifications.filter{$0.type == .declineRoleChange}
        
        let groupedNotifications: [HMSRoomKitNotification] = {
            
            if handRaisedNotifications.count > 1 {
                let combinedHandRaisedNotification = HMSRoomKitNotification(identity: handRaisedNotifications.map{$0.id}.joined(separator: "+"), type: .groupedRaiseHand(ids: handRaisedNotifications.map{$0.id}), actorName: handRaisedNotifications.map{$0.actorName}.joined(separator: ", "), title: "\(handRaisedNotifications.first?.actorName ?? "") and \(handRaisedNotifications.count - 1) other\(handRaisedNotifications.count > 2 ? "s" : "") raised hand", isDismissable: true)
                
                if let lastRaisedHandIndex = roomKitModel.activeNotifications.lastIndex(where: {$0.type == .raiseHand}) {
                    return (roomKitModel.activeNotifications[0..<lastRaisedHandIndex] +  [combinedHandRaisedNotification] + roomKitModel.activeNotifications[(lastRaisedHandIndex + 1)..<roomKitModel.activeNotifications.count]).filter{$0.type != .raiseHand}
                }
            }
            
            if declineRoleChangeNotifications.count > 1 {
                let combinedDeclineRoleChangeNotification = HMSRoomKitNotification(identity: declineRoleChangeNotifications.map{$0.id}.joined(separator: "+"), type: .groupedDeclineRoleChange(ids: declineRoleChangeNotifications.map{$0.id}), actorName: declineRoleChangeNotifications.map{$0.actorName}.joined(separator: ", "), title: "\(declineRoleChangeNotifications.first?.actorName ?? "") and \(declineRoleChangeNotifications.count - 1) other\(declineRoleChangeNotifications.count > 2 ? "s" : "") declined the request to join the stage", isDismissable: true)
                
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
                            default:
                                roomKitModel.dismissNotification(for: notification.id)
                            }
                        }
                    } onAction: {
                        switch notification.action {
                        case .none:
                            break
                        case .bringOnStage:
                            guard !roomInfoModel.onStageRole.isEmpty else { return }
                            Task {
                                guard let peerModel = roomModel.peerModels.first(where: { $0.id == notification.id }) else { return }
                                try await roomModel.changeRole(of: peerModel, to: roomInfoModel.onStageRole)
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
                                try await roomModel.leave()
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
            model.notifications.append(.init(identity: "id1", type: .raiseHand, actorName: "Pawan", title: "Peer1 raised hands Peer1 raised hands", isDismissable: true))
            model.notifications.append(.init(identity: "id2", type: .raiseHand, actorName: "Dmitry", isDismissed: true, title: "Peer2", isDismissable: true))
            model.notifications.append(.init(identity: "id3", type: .raiseHand, actorName: "Praveen", title: "Peer3 raised hands", isDismissable: true))
            model.notifications.append(.init(identity: "id4", type: .raiseHand, actorName: "Bajaj", title: "Peer4 raised hands", isDismissable: true))
            model.notifications.append(.init(identity: "id5", type: .declineRoleChange, actorName: "Bajaj", title: "Peer5 declined request", isDismissable: true))
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

