//
//  PollListEntryView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

class PollListModel: ObservableObject, Identifiable, Hashable {
    internal init(poll: HMSPoll, resultModel: PollVoteViewModel?, createModel: PollCreateModel?) {
        self.resultModel = resultModel
        self.createModel = createModel
        self.title = poll.title
        self.state = poll.state
        self.poll = poll
        
        if let startDate = poll.startedAt, poll.duration > 0 {
            self.endDate =  startDate.addingTimeInterval(TimeInterval(poll.duration))
        }
    }
    
    var id: String {
        poll.pollID
    }
    
    var title: String
    @Published var state: HMSPollState
    var poll: HMSPoll
    
    var createModel: PollCreateModel?
    var resultModel: PollVoteViewModel?
    var endDate: Date?
    
    func hash(into hasher: inout Hasher) {
        poll.pollID.hash(into: &hasher)
    }
    
    func updateValues() {
        self.state = poll.state
    }
    
    static func == (lhs: PollListModel, rhs: PollListModel) -> Bool {
        return lhs.poll.pollID == rhs.poll.pollID
    }
}

struct PollListEntryView: View {
   @ObservedObject var model: PollListModel
   
   var body: some View {
       HStack(alignment: .top) {
           Text(model.title).font(HMSUIFontTheme().subtitle1)
               .foregroundColor(HMSUIColorTheme().onPrimaryHigh)
           Spacer()
           VStack(alignment: .trailing, spacing: 16) {
               PollStateBadgeView(pollState: model.state, endDate: model.endDate)
               Button("View") {
                   
               }.buttonStyle(ActionButtonStyle()).allowsHitTesting(false)
           }.frame(width: 89)
            
       }.padding(16).background(HMSUIColorTheme().surfaceDefault).clipShape(RoundedRectangle(cornerRadius: 8))
   }
}
