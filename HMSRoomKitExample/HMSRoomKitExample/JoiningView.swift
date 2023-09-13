//
//  JoiningView.swift
//  HMSSDKExample
//
//  Created by Pawan Dixit on 04/09/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct JoiningView: View {
    
    var heading4Semibold34 =  Font(UIFont(name: "Inter-SemiBold", size: 34) ?? .systemFont(ofSize: 34))
    var body2Regular14 =  Font(UIFont(name: "Inter-Regular", size: 14) ?? .systemFont(ofSize: 14))
    
    var backgroundDefault: Color = Color(UIColor(red: 11/255, green: 14/255, blue: 21/255, alpha: 1.0))
    var surfaceDefault: Color = Color(UIColor(red: 25/255, green: 27/255, blue: 35/255, alpha: 1.0))
    var primaryDisabled: Color = Color(UIColor(red: 0/255, green: 66/255, blue: 153/255, alpha: 1.0))
    var onPrimaryLow: Color = Color(UIColor(red: 132/255, green: 170/255, blue: 255/255, alpha: 1.0))
    var onPrimaryHigh: Color = Color(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0))
    var primaryDefault: Color = Color(UIColor(red: 37/255, green: 114/255, blue: 237/255, alpha: 1.0))
    
    var heighEmph: Color = Color(UIColor(red: 245/255, green: 249/255, blue: 255/255, alpha: 0.95))
    var mediumEmph: Color = Color(UIColor(red: 224/255, green: 236/255, blue: 255/255, alpha: 0.8))
    var onSurfaceHigh: Color = Color(UIColor(red: 239/255, green: 240/255, blue: 250/255, alpha: 0.8))
    
    @Binding var roomCode: String
    @Binding var isMeetingViewPresented: Bool
    @AppStorage("roomCodeOrRoomLink") var roomCodeOrRoomLink = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack(spacing: 37) {
                
                if !isFocused {
                    Image("logo-icon")
                        .frame(width: 32, height: 32)
                }
                
                Image("illustration")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: isFocused ? 346 * 0.7 : 346, height: isFocused ? 200 * 0.7 : 200)
                
                VStack(spacing: 8) {
                    Text("Experience the power of 100ms")
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.center)
                        .font(heading4Semibold34)
                        .foregroundStyle(heighEmph)
                        .scaleEffect(CGSize(width: isFocused ? 0.8 : 1.0, height: isFocused ? 0.8 : 1.0))
                    
                    if !isFocused {
                        Text("Jump right in by pasting a room link, room code")
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(mediumEmph)
                    }
                    
                }
                
            }
            .animation(.default, value: isFocused)
            
            Spacer(minLength: 0)
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Joining Link or Room Code")
                        .foregroundStyle(onSurfaceHigh)
                        .font(body2Regular14)
                    
                    TextField("", text: $roomCodeOrRoomLink, prompt: Text("Paste the link or room code here").foregroundColor(onSurfaceHigh))
                        .focused($isFocused)
                        .onTapGesture {
                            // block tap
                        }
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(onSurfaceHigh)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(surfaceDefault)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Text("Join Now")
                    .foregroundColor(roomCodeOrRoomLink.isEmpty ? onPrimaryLow : onPrimaryHigh)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(roomCodeOrRoomLink.isEmpty ? primaryDisabled : primaryDefault)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        analyseAndOpenLink(link: roomCodeOrRoomLink)
                    }
            }
            .padding(16)
            .background(backgroundDefault)
        }
        .background(.black)
        .onOpenURL { incomingURL in
            // Assign to text field as well
            roomCodeOrRoomLink = incomingURL.absoluteString
            analyseAndOpenLink(link: incomingURL.absoluteString)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func analyseAndOpenLink(link: String) {
        guard !link.isEmpty else { return }
        
        var link = link
        
        link = link.trimmingCharacters(in: CharacterSet(charactersIn: "/ \\\n"))
        
        var components = link.components(separatedBy: CharacterSet(charactersIn: "/"))
        
        if let lastComponent = components.last {
            roomCode = lastComponent
            
            components.removeLast()
            
            let isQA = components.contains{$0.localizedCaseInsensitiveContains("qa-app")}
            
            if isQA {
                UserDefaults.standard.setValue(true, forKey: "useQAEnv")
                UserDefaults.standard.set("https://auth-nonprod.100ms.live", forKey: "HMSAuthTokenEndpointOverride")
                UserDefaults.standard.set("https://api-nonprod.100ms.live", forKey: "HMSRoomLayoutEndpointOverride")
                //                UserDefaults.standard.set("https://demo8271564.mockable.io", forKey: "HMSRoomLayoutEndpointOverride")
            }
            else {
                UserDefaults.standard.removeObject(forKey: "useQAEnv")
                UserDefaults.standard.removeObject(forKey: "HMSAuthTokenEndpointOverride")
                UserDefaults.standard.removeObject(forKey: "HMSRoomLayoutEndpointOverride")
                //                UserDefaults.standard.set("https://demo8271564.mockable.io", forKey: "HMSRoomLayoutEndpointOverride")
            }
            
            isMeetingViewPresented.toggle()
        }
    }
}

struct JoiningView_Previews: PreviewProvider {
    static var previews: some View {
        JoiningView(roomCode: .constant("as"), isMeetingViewPresented: .constant(false))
    }
}

