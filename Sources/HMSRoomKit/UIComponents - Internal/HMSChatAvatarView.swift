//
//  HMSChatAvatarView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

public struct HMSChatAvatarView: View {
    let text: String
    
    var initials: String {
        text.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
            .reduce("") { partialResult, word in
                partialResult + String(word.first!.uppercased())
            }
    }
    
    
    public init(text: String) {
        self.text = text
    }
    
    public var body: some View {
        ZStack {
            randomColor(for: initials)
            
            Text(initials)
                .font(.body1Regular16)
                .minimumScaleFactor(0.005)
                .foreground(.onSurfaceHigh)
                .padding(4)
        }.clipShape(Circle())
    }
    
    
    func randomColorComponent() -> Int {
        let limit = 214 - 30
        return 30 + Int(drand48() * Double(limit))
    }
    
    func randomColor(for string: String) -> Color {
        srand48(string.hashValue)
        
        let red = CGFloat(randomColorComponent()) / 255.0
        let green = CGFloat(randomColorComponent()) / 255.0
        let blue = CGFloat(randomColorComponent()) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
}

struct HMSChatAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        HMSChatAvatarView(text: "Pawan")
    }
}
