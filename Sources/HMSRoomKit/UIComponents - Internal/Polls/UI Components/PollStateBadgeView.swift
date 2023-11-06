//
//  PollStateBadgeView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 14.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK

struct PollStateBadgeView: View {
    internal init(pollState: HMSPollState = .created, endDate: Date? = nil) {
        self.pollState = pollState
        self.endDate = endDate
        refreshTimeLeft()
    }
    
    var pollState: HMSPollState
    var endDate: Date?
    
    @State private var timeLeft = ""
    private var formatter: DateComponentsFormatter = {
       var result = DateComponentsFormatter()
        result.allowedUnits = [.minute, .second]
        result.unitsStyle = .positional
        return result
    }()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func refreshTimeLeft() {
        if let endDate = endDate, endDate > Date() {
            self.timeLeft = formatter.string(from: Date(), to:endDate ) ?? ""
        } else {
            self.timeLeft = ""
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(pollState.stateString).font(HMSUIFontTheme().overlineMedium)
                .foregroundColor(HMSUIColorTheme().onPrimaryHigh).padding(.horizontal, 8).padding(.vertical, 4).background(pollState == .started ? HMSUIColorTheme().alertErrorDefault : HMSUIColorTheme().surfaceBrighter).clipShape(RoundedRectangle(cornerRadius: 4))
            if pollState == .started && !timeLeft.isEmpty {
                Text(timeLeft).font(HMSUIFontTheme().overlineMedium)
                    .foregroundColor(HMSUIColorTheme().onPrimaryHigh).padding(.horizontal, 8).padding(.vertical, 4).background(HMSUIColorTheme().surfaceBrighter).offset(CGSize(width: -2, height: 0))
            }
            
             
        }.background(HMSUIColorTheme().surfaceBrighter).clipShape(RoundedRectangle(cornerRadius: 4)).onReceive(timer) { time in
           refreshTimeLeft()
        }
    }
}

extension HMSPollState {
    var stateString: String {
        switch self {
        case .created:
            return "DRAFT"
        case .started:
            return "LIVE"
        case .stopped:
            return "ENDED"
        @unknown default:
            return ""
        }
    }
}

struct PollStateBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        return PollStateBadgeView(pollState: .started, endDate: Date(timeIntervalSinceNow: 120))
    }
}
