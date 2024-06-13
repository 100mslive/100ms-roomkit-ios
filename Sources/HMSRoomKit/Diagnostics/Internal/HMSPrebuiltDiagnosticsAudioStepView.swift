//
//  HMSPrebuiltDiagnosticsAudioStepView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 05.06.2024.
//

import SwiftUI
import HMSSDK

class HMSPrebuiltDiagnosticsAudioStepModel: ObservableObject {
    var sdk: HMSDiagnostics
    var onNextStep: (() -> Void)
    
    lazy var recordingModel: HMSPrebuiltDiagnosticsAudioRecordingModel = {
        HMSPrebuiltDiagnosticsAudioRecordingModel(sdk: sdk) { [weak self] result in
            switch result {
            case .success:
                self?.isPlaybackAvailable = true
            case .failure(let error):
                self?.recordingError = error
            }
        }
    }()
    
    @Published var isPlaybackAvailable = false
    @Published var isPlaying = false
    @Published var recordingError: Error?
    @Published var playbackError: Error?
    
    internal init(sdk: HMSDiagnostics, onNextStep: @escaping (() -> Void)) {
        self.sdk = sdk
        self.onNextStep = onNextStep
    }
    
    func nextStep() {
        recordingModel.stopRecording()
        onNextStep()
    }
    
    func playRecording() {
        isPlaying = true
        
        sdk.startSpeakerCheck { [weak self] result in
            self?.isPlaying = false
            
            switch result {
            case .success:
                break
            case .failure(let error):
                self?.recordingError = error
            }
        }
    }
}

class HMSPrebuiltDiagnosticsAudioRecordingModel: ObservableObject {
    var onRecordingResult: ((Result<Bool, Error>) -> Void)
    
    @Published var isRecording = false
    @Published var micLevel: Float = 0.0
    
    var sdk: HMSDiagnostics

    internal init(sdk: HMSDiagnostics, onRecordingResult: @escaping ((Result<Bool, Error>) -> Void)) {
        self.onRecordingResult = onRecordingResult
        self.sdk = sdk
    }
    
    func startRecording() {
        isRecording = true
        
        sdk.startMicCheck(timeInMillis: 10000) { [weak self] result in
            self?.isRecording = false
            self?.onRecordingResult(result)
        } onLevelChange: {  [weak self] level in
            self?.micLevel = (level + 160) / 160
        }
    }
    
    func stopRecording() {
        sdk.stopMicCheck()
        isRecording = false
    }
}

struct HMSPrebuiltDiagnosticsAudioStepView: View {
    @ObservedObject var model: HMSPrebuiltDiagnosticsAudioStepModel
    
    var body: some View {
        HMSPrebuiltDiagnosticsBackgroundStepView(title: "Test Audio", icon: "diag-mic") {
            VStack(alignment: .leading, spacing: 24) {
                Text("Record an audio clip and play it back to check that your microphone and speaker are working. If they aren't, make sure your volume is turned up, try a different speaker or microphone, or check your bluetooth settings.")
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Microphone (Input)")
                        .font(.captionSemibold12)
                        .foreground(.onSurfaceMedium)
                    HMSPrebuiltDiagnosticsAudioRecordingView(model: model.recordingModel)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Speakers (Output)")
                        .font(.captionSemibold12)
                        .foreground(.onSurfaceMedium)
                    Button {
                        guard !model.isPlaying && model.isPlaybackAvailable else { return }
                        model.playRecording()
                    } label: {
                        HStack(spacing: 0) {
                            Image(assetName: "diag-play-button", renderingMode: .original)
                            Text(model.isPlaying ?  "Playing" : "Playback")
                                .font(.subtitle2Semibold14)
                                .foreground(.onSurfaceHigh)
                                .padding(.horizontal, 8)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(model.isPlaybackAvailable ?  .secondaryDefault : .clear, cornerRadius: 4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4).stroke().foreground(model.isPlaybackAvailable ? .clear :   .secondaryDefault)
                        }
                    }
                }
            }
        } prompt: {
            VStack(alignment: .leading, spacing: 16) {
                Text("Does your audio sound good?")
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
                HStack {
                    Text("Yes")
                        .font(.body2Semibold14)
                        .foreground(.onPrimaryHigh)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.primaryDefault, cornerRadius: 4)
                        .onTapGesture {
                            model.nextStep()
                        }
                    Text("No")
                        .font(.body2Semibold14)
                        .foreground(.onPrimaryHigh)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .overlay {
                            RoundedRectangle(cornerRadius: 4).stroke().foreground(.secondaryDefault)
                        }
                        .onTapGesture {
                            model.nextStep()
                        }
                    Spacer()
                }
            }
        }
    }
}


struct HMSPrebuiltDiagnosticsAudioRecordingView: View {
    @ObservedObject var model: HMSPrebuiltDiagnosticsAudioRecordingModel
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                if model.isRecording {
                    model.stopRecording()
                } else {
                    model.startRecording()
                }
            } label: {
                HStack(spacing: 0) {
                    Image(assetName: model.isRecording ? "diag-stop-recording" : "diag-mic-button", renderingMode: .original)
                    Text(model.isRecording ? "Stop Recording..." : "Record")
                        .lineLimit(1)
                        .font(.subtitle2Semibold14)
                        .foreground(.onSurfaceHigh)
                        .padding(.horizontal, 8)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(.secondaryDefault, cornerRadius: 4)
            }
            
            if model.isRecording {
                HStack {
                    Image(assetName: "diag-mic-button", renderingMode: .original)
                    ProgressView(value: model.micLevel)
                }
            }
        }
    }
}


#Preview {
    HMSPrebuiltDiagnosticsAudioStepView(model: HMSPrebuiltDiagnosticsViewModel().audioStepModel()).environmentObject(HMSUITheme())
        .padding()
        .background(.black)
}

