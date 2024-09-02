//
//  HMSCallFeedbackView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 7/29/24.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

struct HMSCallFeedbackView: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var currentTheme: HMSUITheme
    
    let feedback: HMSRoomLayout.LayoutData.Screens.Leave.DefaultLeaveScreen.Elements.Feedback
    
    @State private var selectedResponse: HMSRoomLayout.LayoutData.Screens.Leave.DefaultLeaveScreen.Elements.Feedback.Rating?
    @State private var selectedReasons = Set<String>()
    @State private var additionalComments = ""
    
    @State private var submitted = false
    
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
                    Text(feedback.title)
                        .lineLimit(3)
                        .font(.heading6Semibold20)
                        .foreground(.onSurfaceHigh)
                    
                    Text(feedback.sub_title)
                        .lineLimit(3)
                        .font(.body2Regular14)
                        .foreground(.onSurfaceMedium)
                }
                
                HStack {
                    ForEach(feedback.ratings) { rating in
                        VStack(spacing: 8) {
                            if let emoji = rating.emoji {
                                Text(emoji)
                                    .font(.system(size: 32))
                                    .foreground(.onSurfaceHigh)
                                    .opacity(selectedResponse == nil || selectedResponse == rating ? 1.0 : 0.2)
                            }
                            Text(rating.label)
                                .font(selectedResponse == rating  ? .body2Semibold14 : .body2Regular14)
                                .foreground(selectedResponse == nil ? .onSurfaceMedium : (selectedResponse == rating ? .onSurfaceHigh : .onSurfaceLow))
                                .frame(maxWidth: .infinity)
                        }
                        
                        .onTapGesture {
                            selectedResponse = rating
                        }
                        Spacer()
                    }
                }.onChange(of: selectedResponse) { _ in
                    selectedReasons.removeAll()
                }
                
                if let selectedResponse = selectedResponse, 
                    let reasons = selectedResponse.reasons,
                    !reasons.isEmpty {
                    HMSDivider(color: currentTheme.colorTheme.borderDefault)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        if let question = selectedResponse.question {
                            Text(question)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.subtitle2Semibold14)
                                .foreground(.onSurfaceHigh)
                        }
                        ScrollView {
                            FlexibleView(data: reasons,
                                         spacing: 8,
                                         alignment: .leading) { reason in
                                Toggle(isOn: Binding(get: {
                                    selectedReasons.contains(reason)
                                }, set: { value in
                                    if selectedReasons.contains(reason) {
                                        selectedReasons.remove(reason)
                                    }
                                    else {
                                        selectedReasons.insert(reason)
                                    }
                                })) {
                                    Text(reason)
                                        .foreground(.onSurfaceHigh)
                                        .font(.body2Regular14)
                                }
                                .padding(12)
                                .toggleStyle(CheckboxStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .strokeBorder(.gray, lineWidth: 1)
                                )
                            }
                        }
                        .frame(height: 100)
                    }
                    
                    if let comment = feedback.comment {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(comment.label)
                                .font(.body2Regular14)
                                .foreground(.onSurfaceHigh)
                            
                            ZStack(alignment: .topLeading) {
                                if additionalComments.isEmpty {
                                    VStack {
                                        Text(comment.placeholder)
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
                                                .frame(height: 112)
                                                .scrollContentBackground(.hidden)
                                                .background(.surfaceDefault, cornerRadius: 8)
                                        } else {
                                            TextEditor(text: $additionalComments)
                                                .frame(height: 112)
                                                .background(.surfaceDefault, cornerRadius: 8)
                                                .onAppear() {
                                                    UITextView.appearance().backgroundColor = .clear
                                                }
                                        }
                                    }
                                    .opacity(additionalComments.isEmpty ? 0.5 : 1)
                                }
                            }
                        }
                    }
                    
                    Text(feedback.submit_btn_label ?? "Submit Feedback")
                        .font(.buttonSemibold16)
                        .foreground(.onPrimaryHigh)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(.primaryDefault, cornerRadius: 8)
                        .onTapGesture {
                            Task {
                                submitted = true
                                let reasons = selectedReasons.isEmpty ? nil : Array(selectedReasons)
                                let feedbackResult = HMSSessionFeedback(question: feedback.title, rating: selectedResponse.value, reasons: reasons, comment: additionalComments)
                                do {
                                    try await roomModel.submitFeedback(feedbackResult)
                                } catch {
                                    try await roomModel.submitFeedback(feedbackResult)
                                }
                            }
                        }
                }
            }
        }
        .padding([.horizontal, .top], 24)
        .background(.surfaceDim, cornerRadius: 0)
    }
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

extension HMSRoomLayout.LayoutData.Screens.Leave.DefaultLeaveScreen.Elements.Feedback.Rating: Identifiable, Equatable {
    public static func == (lhs: HMSRoomLayout.LayoutData.Screens.Leave.DefaultLeaveScreen.Elements.Feedback.Rating, rhs: HMSRoomLayout.LayoutData.Screens.Leave.DefaultLeaveScreen.Elements.Feedback.Rating) -> Bool {
        return lhs.value == rhs.value
    }
    
    public var id: Int {
        return value
    }
}
