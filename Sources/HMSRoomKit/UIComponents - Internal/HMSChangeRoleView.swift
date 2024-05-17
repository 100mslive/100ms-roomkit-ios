//
//  HMSChangeRoleView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 5/1/24.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSChangeRoleView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var peerModel: HMSPeerModel
    let roleName: String
    @State var selectedRole: HMSRole?

    var body: some View {
        
        let candidateRoles = roomModel.roles.filter{$0.name != roleName}
        
        VStack(spacing: 0) {
            HMSOptionsHeaderView(title: "Switch Role", subtitle: "Switch the role of '\(peerModel.name)' from '\(roleName)' to") {
                presentationMode.wrappedValue.dismiss()
            } onBack: {}
            VStack(spacing: 16) {
                
                if let selectedRole {
                    Picker(selection: $selectedRole) {
                        ForEach(candidateRoles, id: \.self) { role in
                            Text(role.name)
                                .tag(role as HMSRole?)
                        }
                    } label: {
                        Text(selectedRole.name)
                            .font(.body1Regular16)
                            .foreground(.onSurfaceHigh)
                    }
                    .pickerStyle(.inline)
                    .colorScheme(.dark)
                    .background(.surfaceDefault, cornerRadius: 8)
                }
                Text("Switch Role")
                    .font(.body1Semibold16)
                    .foreground(.onPrimaryHigh)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, maxHeight: 48, alignment: .center)
                    .background(.primaryDefault, cornerRadius: 8)
                    .onTapGesture {
                        guard let selectedRole else { return }
                        Task {
                            try await roomModel.changeRole(of:peerModel, to:selectedRole.name, shouldAskForApproval: false)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .padding(.horizontal, 24)
            .onAppear() {
                selectedRole = candidateRoles.first
            }
        }
    }
}

struct HMSChangeRoleView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSChangeRoleView(peerModel: .init(), roleName: "host")
            .environmentObject(HMSUITheme())
            .environmentObject(HMSPrebuiltOptions())
            .environmentObject(HMSRoomModel.dummyRoom(3)).background(HMSUITheme().colorTheme.surfaceDim)
#endif
    }
}
