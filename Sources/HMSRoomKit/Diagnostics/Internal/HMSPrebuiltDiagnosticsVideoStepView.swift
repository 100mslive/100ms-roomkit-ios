//
//  HMSPrebuiltDiagnosticsVideoStepView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 05.06.2024.
//

import SwiftUI
import HMSSDK
import HMSRoomModels

class HMSPrebuiltDiagnosticsVideoStepModel: ObservableObject {
    var sdk: HMSDiagnostics
    var onNextStep: (() -> Void)
    @Published var trackModel: HMSTrackModel?

    internal init(sdk: HMSDiagnostics, onNextStep: @escaping (() -> Void)) {
        self.sdk = sdk
        self.onNextStep = onNextStep
    }
    
    func cameraOptions() -> [String] {
        return ["Front Camera", "Back Camera"]
    }
    
    func startCameraCheck(_ selectedCamera: String) {
        var device: HMSVideoInputDevice
        
        switch selectedCamera {
        case "Back Camera":
            device = .backCamera
        default:
            device = .frontCamera
        }
        
        sdk.startCameraCheck(device: device) { [weak self] result in
            switch result {
            case .success(let track):
                self?.trackModel = HMSTrackModel(track: track, peerModel: nil)
            case .failure(_):
                break
            }
        }
    }
    
    func stopCameraCheck() {
        trackModel = nil
        sdk.stopCameraCheck()
    }
    
    func nextStep() {
        onNextStep()
    }
}

struct HMSPrebuiltDiagnosticsVideoStepView: View {
    @ObservedObject var model: HMSPrebuiltDiagnosticsVideoStepModel
    @State var selectedOption: String = ""
    
    @State var isChanged = false
    
    var body: some View {
        HMSPrebuiltDiagnosticsBackgroundStepView(title: "Test Video", icon: "diag-camera") {
            VStack(spacing: 24) {
                if let trackModel = model.trackModel {
                    HMSTrackView(track: trackModel, contentMode: .scaleAspectFill, isZoomAndPanEnabled: false).frame(width: 146, height: 260).clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(alignment: .topTrailing) {
                            Image(assetName: "switch-camera-icon")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foreground(.onSurfaceHigh)
                                .padding(8)
                                .background(.secondaryDim, cornerRadius: 20)
                                .padding(8)
                                .onTapGesture {
                                    (trackModel.track as? HMSLocalVideoTrack)?.switchCamera()
                                }
                        }
                }
                Text("Move in front of your camera to make sure it's working. If you don't see your video, try changing the selected camera. If the camera isn't part of your computer, check your settings to make sure your system recognizes it.")
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
            }
            .onAppear {
                selectedOption = model.cameraOptions().first ?? ""
            }
            .onChange(of: selectedOption) { _ in
                model.stopCameraCheck()
                model.startCameraCheck(selectedOption)
            }
        } prompt: {
            VStack(alignment: .leading, spacing: 16) {
                Text("Does your video look ok?")
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
                            model.stopCameraCheck()
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
                            model.stopCameraCheck()
                            model.nextStep()
                        }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HMSPrebuiltDiagnosticsVideoStepView(model: HMSPrebuiltDiagnosticsViewModel().videoStepModel()).environmentObject(HMSUITheme())
        .padding()
        .background(.black)
}
