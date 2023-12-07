//
//  PollQuestionsView.swift
//  HMSSDKExample
//
//  Created by Dmitry Fedoseyev on 21.06.2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct PollQuestionsView: View {
    @ObservedObject var model: QuestionCreateModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("QUESTION \(model.index) of \(model.count)").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().captionRegular).frame(maxWidth: .infinity, alignment: .leading)

            if model.editing {
                HMSPickerField(title:"Question Type", options: model.options, selectedOption: $model.selectedOption)
                PollTextField(placeholder: "Ask a question", text: $model.text, valid: model.valid)
            } else {
                Text(model.text).foregroundColor(HMSUIColorTheme().onPrimaryHigh).font(HMSUIFontTheme().body1Regular16)
            }
            
            if (model.editing ) {
                if (model.type == .singleChoice || model.type == .multipleChoice) {
                    Text("Options").foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().body2Regular14)
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(model.questionOptions) { option in
                            PollOptionView(model: option)
                        }
                    }
                    
                    if model.editing {
                        Button {
                            model.addOption()
                        } label: {
                            Label("Add an option", systemImage: "plus.circle")
                        }.buttonStyle(HMSIconTextButtonStyle())
                    }
                }
                if (model.showAnswerSelection) {
                    HStack {
                        Text("Point Weightage").foregroundColor(HMSUIColorTheme().onSurfaceMedium).font(HMSUIFontTheme().body2Regular14)
                        Spacer()
                        PollTextField(placeholder: "", text: $model.weight, valid: true, keyboardType: .numberPad).frame(width: 88)
                    }
                }
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(model.questionOptions) { option in
                        Text(option.text).foregroundColor(HMSUIColorTheme().onPrimaryMedium).font(HMSUIFontTheme().body2Regular14)
                    }
                }
            }
            if !model.valid || !model.optionsValid {
                Text("Please fill the fields to Save.").foregroundColor(HMSUIColorTheme().alertErrorDefault).font(HMSUIFontTheme().body2Regular14)
            } else if !model.answersSelected {
                Text("Please select an answer for the question.").foregroundColor(HMSUIColorTheme().alertErrorDefault).font(HMSUIFontTheme().body2Regular14)
            }
            HStack {
                if model.index > 1 {
                    Button {
                        model.delete()
                    } label: {
                        Label("", systemImage: "trash")
                    }.buttonStyle(HMSIconTextButtonStyle()).allowsHitTesting(!model.loading).opacity(model.loading ? 0 : 1 )
                }
                Spacer()
                
                Button {
                    model.editing ? model.save() : model.edit()
                } label: {
                    if model.loading {
                        ProgressView()
                    } else {
                        Text(model.editing ? "Save" : "Edit")
                    }
                }.buttonStyle(ActionButtonLowEmphStyle()).allowsHitTesting(!model.loading)
            }
        }.padding(16).background(HMSUIColorTheme().surfaceDefault).clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

