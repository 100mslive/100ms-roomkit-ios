//
//  HMSTranscriptView.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 4/2/24.
//

import SwiftUI
import HMSRoomModels

struct HMSTranscriptView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.captionsState) var captionsState
    @Environment(\.controlsState) var controlsState
    
    @Environment(\.conferenceParams) var conferenceComponentParam
    
    @Binding var isChatPresented: Bool
    
    class ViewState: ObservableObject {
        @Published var activity: Activity = .speaking
        @Published var expiredTranscriptionLength = 0
    }
    
    enum Activity {
        case none, speaking
    }
    
    @StateObject var state: ViewState = .init()
    
    @State var hideTasks = [Task<(), any Error>]()
    var hideTranscriptTask: Task<(), any Error> {
        Task {
            try await Task.sleep(nanoseconds: 5_000_000_000)
            state.activity = .none
            state.expiredTranscriptionLength = roomModel.transcript.count
        }
    }
    
    @EnvironmentObject var roomModel: HMSRoomModel
    
    var body: some View {
        
        let isChatOverlay = conferenceComponentParam.chat?.isOverlay ?? false
        
        if !(isChatOverlay && isChatPresented) {
            if roomModel.isTranscriptionAvailable {
                if captionsState.wrappedValue == .visible {
                    viewBody
                }
            }
        }
        else {
            if roomModel.isTranscriptionAvailable {
                if captionsState.wrappedValue == .visible {
                    HMSTopControlStrip()
                        .padding([.bottom,.horizontal], 8)
                        .transition(.move(edge: .top))
                        .frame(height: controlsState.wrappedValue == .hidden ? 0 : nil)
                        .opacity(0)
                    
                    viewBody
                    
                    Spacer()
                }
            }
        }
    }
    
    var viewBody: some View {
        VStack {
            if state.activity == .speaking {
                let freshTranscriptLength = max(roomModel.transcript.count - state.expiredTranscriptionLength, 0)
                let transcript = roomModel.transcript.suffix(min(freshTranscriptLength, 400))
                
                let speakerLabel: String = {
                    // if current transcript lacks speaker label then show recent speaker label ourselves
                    if transcript.first == "\n" {
                        return ""
                    }
                    else {
                        let lastSpeakerName = lastTranscriptLabel(transcript: String(roomModel.transcript.prefix(state.expiredTranscriptionLength)))
                        return "\(lastSpeakerName): "
                    }
                }()
                
                let trimmedTranscript = speakerLabel.isEmpty ? String(transcript.trimmingCharacters(in: .newlines)) : String(transcript)
                
                // Don't show empty transcript
                if !transcript.isEmpty {
                    VStack {
                        Text("\(Text(.init("\(speakerLabel)")).font(HMSUIFontTheme().body2Semibold14))\(Text(.init("\(trimmedTranscript)")).font(HMSUIFontTheme().body2Regular14))")
                            .lineLimit(nil)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxHeight: 66, alignment: .bottom)
                    .fixedSize(horizontal: false, vertical: true)
                    .clipped()
                    .padding(12)
                    .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
                    .padding(8)
                    .padding(.horizontal, verticalSizeClass == .regular ? 0 : 64)
                }
            }
        }
        .onAppear() {
            restartHideTasks()
        }
        .onChange(of: roomModel.transcript) { transcript in
            restartHideTasks()
        }
    }
    
    func restartHideTasks() {
        // Cancel hiding transcript if there is new transcription activity
        hideTasks.forEach{$0.cancel()}
        hideTasks.removeAll()
        state.activity = .speaking
        hideTasks.append(hideTranscriptTask)
    }
    
    public func lastTranscriptLabel(transcript: String) -> String {
        let lines = transcript.split(separator: "\n")
        guard let lastLine = lines.last else { return "" }
        let components = lastLine.split(separator: ":", maxSplits: 1)
        guard let lastSpeaker = components.first else { return "" }
        return String(lastSpeaker).trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "*", with: "")
    }
}

struct HMSTranscriptView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        HMSTranscriptView(isChatPresented: .constant(true))
            .environmentObject(HMSRoomModel.dummyRoom(2))
            .environmentObject(HMSUITheme())
#endif
    }
}
