//
//  HMSRecordSessionMenuButton.swift
//  HMSRoomKit
//
//  Created by Dmitry Fedoseyev on 06.11.2023.
//

import SwiftUI
import HMSRoomModels

struct HMSRecordSessionMenuButton: View {
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var buttonText: String {
        switch roomModel.recordingState {
        case .starting, .started, .resumed:
            return "Recording"
        case .paused:
            return "Recording\nPaused"
        default:
            return "Record"
        }
    }
    
    var buttonImage: String {
        switch roomModel.recordingState {
        case .starting, .started, .resumed:
            return "record-on"
        case .paused:
            return "Recording\nPaused"
        default:
            return "record-on"
        }
    }
    
    var buttonImageColor: HMSThemeColor? {
        switch roomModel.recordingState {
        case .starting, .started, .resumed:
            return .errorDefault
        default:
            return nil
        }
    }
    
    var body: some View {
        HMSSessionMenuButton(text: buttonText, image: buttonImage, highlighted: false, isDisabled: roomModel.isUserHLSViewer, imageForeground: buttonImageColor)
    }
}
