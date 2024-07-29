//
//  HMSCallFeedbackView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 7/29/24.
//

import SwiftUI

struct HMSCallFeedbackView: View {
    
    enum Response {
        case awful, bad, fair, good, great
        
        enum Reason: String {
            case couldNotHear = "Could not hear others"
            case Freezes = "Freezes"
            case couldNotSee = "Could not see others"
        }
        
        var reasonsForResponse: [Reason] {
            switch self {
            case .awful:
                [.couldNotHear, .Freezes, .couldNotSee]
            case .bad:
                [.couldNotHear, .Freezes, .couldNotSee]
            case .fair:
                [.couldNotHear, .Freezes, .couldNotSee]
            case .good:
                [.couldNotHear, .Freezes, .couldNotSee]
            case .great:
                [.couldNotHear, .Freezes, .couldNotSee]
            }
        }
    }
    
    @State var selectedResponse: Response?
    @State var selectedReasons = Set<Response.Reason>()
    @State var additionalComments = ""
    
    @State var submitted = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            
            if submitted {
                VStack(alignment: .center, spacing: 4) {
                    
                    Image(assetName: "user-music")
                        .renderingMode(.original)
                    
                    Text("Thank you for your feedback!")
                        .font(.heading6Semibold20)
                        .foreground(.onSurfaceHigh)
                    
                    Text("Your answers help us improve.")
                        .font(.body2Regular14)
                        .foreground(.onSurfaceMedium)
                }
            }
            else {
                VStack(alignment: .leading, spacing: 4) {
                    Text("How was your experience?")
                        .font(.heading6Semibold20)
                        .foreground(.onSurfaceHigh)
                    
                    Text("Your answers help us improve the quality.")
                        .font(.body2Regular14)
                        .foreground(.onSurfaceMedium)
                }
                
                HStack {
                    VStack {
                        Text("😔")
                            .font(.heading6Semibold20)
                            .foreground(.onSurfaceHigh)
                        Text("Awful")
                            .font(.body2Regular14)
                            .foreground(.onSurfaceMedium)
                    }
                    .opacity(selectedResponse == nil || selectedResponse == .awful ? 1.0 : 0.2)
                    .onTapGesture {
                        selectedResponse = .awful
                    }
                    Spacer()
                    VStack {
                        Text("☹️")
                            .font(.heading6Semibold20)
                            .foreground(.onSurfaceHigh)
                        Text("Bad")
                            .font(.body2Regular14)
                            .foreground(.onSurfaceMedium)
                    }
                    .opacity(selectedResponse == nil || selectedResponse == .bad ? 1.0 : 0.2)
                    .onTapGesture {
                        selectedResponse = .bad
                    }
                    Spacer()
                    VStack {
                        Text("🙂")
                            .font(.heading6Semibold20)
                            .foreground(.onSurfaceHigh)
                        Text("Fair")
                            .font(.body2Regular14)
                            .foreground(.onSurfaceMedium)
                    }
                    .opacity(selectedResponse == nil || selectedResponse == .fair ? 1.0 : 0.2)
                    .onTapGesture {
                        selectedResponse = .fair
                    }
                    Spacer()
                    VStack {
                        Text("😄")
                            .font(.heading6Semibold20)
                            .foreground(.onSurfaceHigh)
                        Text("Good")
                            .font(.body2Regular14)
                            .foreground(.onSurfaceMedium)
                    }
                    .opacity(selectedResponse == nil || selectedResponse == .good ? 1.0 : 0.2)
                    .onTapGesture {
                        selectedResponse = .good
                    }
                    Spacer()
                    VStack {
                        Text("🤩")
                            .font(.heading6Semibold20)
                            .foreground(.onSurfaceHigh)
                        Text("Great")
                            .font(.body2Regular14)
                            .foreground(.onSurfaceMedium)
                    }
                    .opacity(selectedResponse == nil || selectedResponse == .great ? 1.0 : 0.2)
                    .onTapGesture {
                        selectedResponse = .great
                    }
                }
                
                if let selectedResponse {
                    
                    Divider()
                    
                    Text("What went wrong?")
                        .font(.heading6Semibold20)
                        .foreground(.onSurfaceHigh)
                    
                    VStack {
                        FlexibleView(data: selectedResponse.reasonsForResponse,
                                     spacing: 8,
                                     alignment: .leading) { response in
                            VStack {
                                HStack {
                                    Toggle(isOn: Binding(get: {
                                        selectedReasons.contains(response)
                                    }, set: { value in
                                        if selectedReasons.contains(response) {
                                            selectedReasons.remove(response)
                                        }
                                        else {
                                            selectedReasons.insert(response)
                                        }
                                    })) {
                                        Text(response.rawValue)
                                            .foreground(.onSurfaceHigh)
                                            .font(.body2Regular14)
                                    }
                                    .padding(12)
                                    .toggleStyle(CheckboxStyle())
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(.gray, lineWidth: 1)
                            )
                        }
                    }
                    
                    Text("Additional comments (optional)")
                        .font(.body2Regular14)
                        .foreground(.onSurfaceHigh)
                    
                    ZStack(alignment: .topLeading) {
                        if additionalComments.isEmpty {
                            VStack {
                                Text("Tell us more...")
                                    .font(.body1Regular16)
                                    .foreground(.onSurfaceMedium)
                                    .padding(.top, 10)
                                    .padding(.leading, 6)
                                    .opacity(1.0)
                            }
                        }
                        
                        VStack {
                            HStack {
                                if #available(iOS 16.0, *) {
                                    TextEditor(text: $additionalComments)
                                        .frame(height: 140)
                                        .scrollContentBackground(.hidden)
                                        .background(.surfaceDefault, cornerRadius: 8)
                                } else {
                                    TextEditor(text: $additionalComments)
                                        .frame(height: 140)
                                        .background(.surfaceDefault, cornerRadius: 8)
                                        .onAppear() {
                                            UITextView.appearance().backgroundColor = .clear
                                        }
                                }
                            }
                            .opacity(additionalComments.isEmpty ? 0.5 : 1)
                        }
                    }
                    
                    Text("Submit Feedback")
                        .font(.buttonSemibold16)
                        .foreground(.onPrimaryHigh)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(.primaryDefault, cornerRadius: 8)
                        .onTapGesture {
                            // Submit the form
                            
                            submitted = true
                        }
                }
            }
        }
        .animation(.default, value: selectedResponse)
        .padding([.horizontal, .top], 24)
        .background(.surfaceDim, cornerRadius: 0)
    }
}

#Preview {
    HMSCallFeedbackView()
        .environmentObject(HMSUITheme())
}

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foreground(configuration.isOn ? .primaryBright : .onSurfaceLow)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
