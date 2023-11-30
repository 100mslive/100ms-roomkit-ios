//
//  HMSRolePickerView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSRolePickerOptionsView: View {
    
    @Environment(\.conferenceParams) var conferenceParams
    
    @EnvironmentObject var currentTheme: HMSUITheme
    @EnvironmentObject var roomModel: HMSRoomModel
    @Binding var selectedOption: HMSRecipient
    
    @State var searchQuery: String = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        let chatScopes = conferenceParams.chat?.chatScopes
        
        var allowedRoles: [HMSRole] {
            
            if let chatScopes {
                if let roleScope = chatScopes.first(where: { scope in
                    switch scope {
                    case .roles(_):
                        return true
                    default:
                        return false
                    }
                }) {
                    if case let .roles(whiteList: whiteListedRoles) = roleScope {
                        return roomModel.roles.filter{whiteListedRoles.contains($0.name)}
                    }
                }
            }
            
            // by default no roles are allowed
            return []
        }
        
        let filteredRoles = allowedRoles.filter{ searchQuery.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchQuery)}
        
        var filteredPeers: [HMSPeerModel] {
            if let chatScopes, chatScopes.contains(.private) {
                return roomModel.remotePeerModels.filter{ searchQuery.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchQuery)}
            }
            else {
                return []
            }
        }
        
        if let chatScopes {
            VStack(spacing: 0) {
                HMSOptionsHeaderView(title: "Send message to") {
                    dismiss()
                } onBack: {}
                HStack {
                    HMSSearchField(searchText: $searchQuery, placeholder: "Search for participants", style: .dark)
                }.padding(.horizontal, 24)
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        
                        // Always show everyone chat.
//                        if chatScopes.contains(.public) {
                            Button {
                                selectedOption = .everyone
                                dismiss()
                            } label: {
                                HStack {
                                    Image(assetName: "group")
                                        .foreground(.onSurfaceHigh)
                                    Text(HMSRecipient.everyone.toString())
                                        .font(.subtitle2Semibold14)
                                        .foreground(.onSurfaceHigh)
                                    
                                    Spacer()
                                    
                                    if selectedOption == .everyone {
                                        Image(assetName: "checkmark")
                                            .resizable()
                                            .foreground(.onSurfaceHigh)
                                            .frame(width: 20, height: 20)
                                    }
                                }
                                .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
                                .background(.white.opacity(0.0001))
                            }
                            .buttonStyle(.plain)
                            HMSDivider(color: currentTheme.colorTheme.borderBright)
//                        }
                        
                        if filteredRoles.count > 0 {
                            
                            Text("Roles")
                                .font(.overlineMedium)
                                .foreground(.onSurfaceMedium)
                                .padding(EdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 0))
                            
                            ForEach(filteredRoles.sorted(by: {
#if Preview
                                return true
#else
                                
                                let peerRecipients = roomModel.messages.compactMap{$0.recipient.rolesRecipient}.flatMap{$0}.reversed()
                                guard let index1 = peerRecipients.firstIndex(of: $0),
                                      let index2 = peerRecipients.firstIndex(of: $1) else {
                                    return false
                                }
                                return index1 < index2
#endif
                            }), id: \.name) { role in
                                Button {
                                    selectedOption = .role(role)
                                    dismiss()
                                } label: {
                                    HStack {
                                        Text(role.name.capitalized)
                                            .font(.subtitle2Semibold14)
                                            .foreground(.onSurfaceHigh)
                                            .padding(.vertical, 14)
                                            .padding(.horizontal, 24)
                                        
                                        Spacer()
                                        
                                        if selectedOption == .role(role) {
                                            Image(assetName: "checkmark")
                                                .resizable()
                                                .foreground(.onSurfaceHigh)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    .padding(.trailing, 24)
                                    .background(.white.opacity(0.0001))
                                }
                                .buttonStyle(.plain)
                            }
                            
                            HMSDivider(color: currentTheme.colorTheme.borderBright)
                        }

                        if filteredPeers.count > 0 {
                            Text("Participants")
                                .font(.overlineMedium)
                                .foreground(.onSurfaceMedium)
                                .padding(EdgeInsets(top: 16, leading: 24, bottom: 0, trailing: 0))
                            ForEach(filteredPeers.sorted(by: {
                                
#if Preview
                                return true
#else
                                
                                let peerRecipients = roomModel.messages.compactMap{$0.recipient.peerRecipient}.reversed()
                                guard let index1 = peerRecipients.firstIndex(of: $0.peer),
                                      let index2 = peerRecipients.firstIndex(of: $1.peer) else {
                                    return false
                                }
                                return index1 < index2
#endif
                                
                            })) { peer in
                                Button {
                                    selectedOption = .peer(peer)
                                    dismiss()
                                } label: {
                                    HStack {
                                        Text(peer.name)
                                            .font(.subtitle2Semibold14)
                                            .foreground(.onSurfaceHigh)
                                            .padding(.vertical, 14)
                                            .padding(.horizontal, 24)
                                        
                                        Spacer()
                                        
                                        if selectedOption == .peer(peer) {
                                            Image(assetName: "checkmark")
                                                .resizable()
                                                .foreground(.onSurfaceHigh)
                                                .frame(width: 20, height: 20)
                                        }
                                    }
                                    .padding(.trailing, 24)
                                    .background(.white.opacity(0.0001))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: (filteredRoles.count + filteredPeers.count) > 8 ? false : true)
            }
            .background(.surfaceDefault, cornerRadius: 8, ignoringEdges: .all)
        }
    }
}


struct HMSRolePickerOptionsView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSRolePickerOptionsView(selectedOption: .constant(.everyone))
            .environmentObject(HMSUITheme())
            .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
    }
}
