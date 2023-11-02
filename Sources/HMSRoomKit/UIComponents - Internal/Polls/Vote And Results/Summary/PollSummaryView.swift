//
//  PollSummaryView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct PollSummaryView: View {
    @ObservedObject var model: PollSummaryViewModel
    
    internal init(model: PollSummaryViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .trailing) {
            ForEach(model.items) { itemRow in
                HStack() {
                    ForEach(itemRow.items) { item in
                        PollSummaryItemView(model: item)
                    }
                }
            }
        }
    }
}

struct PollSummaryItemView: View {
    @ObservedObject var model: PollSummaryItemViewModel
    
    internal init(model: PollSummaryItemViewModel) {
        self.model = model
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(model.title).foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().overlineMedium)
            Spacer().frame(maxWidth: .infinity, maxHeight: 8)
            Text(model.subtitle).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body1Semibold16)
            Spacer().frame(maxWidth: .infinity, maxHeight: 1)
        }.padding(16).background(HMSUIColorTheme().surfaceBright).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
