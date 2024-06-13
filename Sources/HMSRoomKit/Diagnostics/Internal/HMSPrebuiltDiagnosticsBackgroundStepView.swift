//
//  HMSPrebuiltDiagnosticsBackgroundStepView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 06.06.2024.
//

import SwiftUI

struct HMSPrebuiltDiagnosticsBackgroundStepView<Content, Prompt>: View where Content : View, Prompt : View {
    let title: String
    let icon: String
    let showsPrompt: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let prompt: () -> Prompt
    @EnvironmentObject var currentTheme: HMSUITheme
    
    public init(title: String, icon: String, showsPrompt: Bool = true, @ViewBuilder content: @escaping () -> Content, @ViewBuilder prompt: @escaping () -> Prompt) {
        self.title = title
        self.icon = icon
        self.showsPrompt = showsPrompt
        self.content = content
        self.prompt = prompt
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(spacing: 14) {
                Image(assetName: icon).renderingMode(.original)
                Text(title).font(.subtitle1).foreground(.onSurfaceHigh)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            HMSDivider(color: currentTheme.colorTheme.borderDefault)
            content().padding(24)
            if showsPrompt {
                HMSDivider(color: currentTheme.colorTheme.borderDefault)
                prompt().padding(24)
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 19/255, green: 22/255, blue: 27/2555, opacity: 0.28), Color(red: 19/255, green: 22/255, blue: 27/2555, opacity: 0.42)]), startPoint: .leading, endPoint: .trailing)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8).stroke().foreground(.borderDefault)
        }
        
    }
}
