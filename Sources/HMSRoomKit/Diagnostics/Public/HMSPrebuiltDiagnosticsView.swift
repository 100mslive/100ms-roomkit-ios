//
//  HMSPrebuiltDiagnosticsView.swift
//  HMSRoomKitDevelopment
//
//  Created by Dmitry Fedoseyev on 05.06.2024.
//

import SwiftUI
import HMSSDK

enum HMSPrebuiltDiagnosticsStep: CaseIterable {
    case region
    case video
    case audio
    case connectivity
    
    private var allCases: AllCases { Self.allCases }
    var next: Self {
        let index = allCases.index(after: allCases.firstIndex(of: self)!)
        guard index != allCases.endIndex else { return allCases.first! }
        return allCases[index]
    }
}

class HMSPrebuiltDiagnosticsViewModel: ObservableObject {
    @Published var step: HMSPrebuiltDiagnosticsStep = .region
    
    @Published var region = "us"
    
    @Published var progress: CGFloat = CGFloat(1) / CGFloat(HMSPrebuiltDiagnosticsStep.allCases.count)
    @Published var permissionsGranted = true

    lazy var sdk: HMSDiagnostics = {
        HMSSDK.build().getDiagnosticsSDK()
    }()
    
    func checkPermissions() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] response in
            DispatchQueue.main.async {
                if response {
                    AVAudioSession.sharedInstance().requestRecordPermission() { allowed in
                        DispatchQueue.main.async {
                            self?.permissionsGranted = allowed
                        }
                    }
                } else {
                    self?.permissionsGranted = false
                }
            }
        }
    }
    
    func nextStep() {
        guard step != .connectivity else { return }
        
        progress += CGFloat(1) / CGFloat(HMSPrebuiltDiagnosticsStep.allCases.count)
        
        step = step.next
    }
    
    func videoStepModel() -> HMSPrebuiltDiagnosticsVideoStepModel {
        HMSPrebuiltDiagnosticsVideoStepModel(sdk: sdk) { [weak self] in
            self?.nextStep()
        }
    }
    
    func audioStepModel() -> HMSPrebuiltDiagnosticsAudioStepModel {
        HMSPrebuiltDiagnosticsAudioStepModel(sdk: sdk) { [weak self] in
            self?.nextStep()
        }
    }
    
    func connectivityStepModel() -> HMSPrebuiltDiagnosticsConnectivityStepModel {
        HMSPrebuiltDiagnosticsConnectivityStepModel(sdk: sdk, region: region) { [weak self] in
            self?.nextStep()
        }
    }
}

public struct HMSPrebuiltDiagnosticsView: View {
    private var onDismiss: (() -> Void)?
    private var currentTheme = HMSUITheme()
    @StateObject private var model = HMSPrebuiltDiagnosticsViewModel()
    
    public init(onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HMSCustomSlider($model.progress, max: 1).trackSize(8).cornerRadius(0).activeTrack(AnyView(currentTheme.colorTheme.primaryDefault)).inactiveTrack(AnyView(currentTheme.colorTheme.secondaryDisabled)).indicator(nil).allowsHitTesting(false)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        Image(assetName: "diag-back", renderingMode: .original)
                            .onTapGesture {
                                onDismiss?()
                            }
                        if model.step != .region {
                            Text("Pre-call Test")
                                .font(.heading5Semibold24)
                                .foreground(.onPrimaryHigh)
                        }
                        Spacer()
                    }.padding(.top, 32)
                    
                    
                    switch model.step {
                    case .region:
                        HMSPrebuiltDiagnosticsRegionStepView(region: $model.region, onNextStep: { model.nextStep() }).padding(.top, 100)
                    case .video:
                        HMSPrebuiltDiagnosticsVideoStepView(model: model.videoStepModel())
                    case .audio:
                        HMSPrebuiltDiagnosticsAudioStepView(model: model.audioStepModel())
                    case .connectivity:
                        HMSPrebuiltDiagnosticsConnectivityStepView(model: model.connectivityStepModel())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .background(
            Image(assetName: "diagnostics-bg")
                            .renderingMode(.original)
        )
        .background(Color(UIColor(red: 5/255, green: 5/255, blue: 6/255, alpha: 1.0)))
        .overlay() {
            if !model.permissionsGranted {
                VStack {
                    Spacer()
                    HMSPermissionsRequiredAlertView()
                    Spacer()
                }
                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.8))
            }
        }
        .environmentObject(currentTheme)
        .onAppear {
            model.checkPermissions()
        }
    }
}

struct HMSPermissionsRequiredAlertView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 8) {
                Text("Allow access to your microphone and camera")
                    .font(.heading6Semibold20)
                    .foreground(.onSurfaceHigh)
                Text("In order to test your audio and video quality, your app needs camera and microphone access.")
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
                HStack {
                    Spacer()
                    HStack {
                        Text("Open Settings")
                            .font(.body2Semibold14)
                            .foreground(.onPrimaryHigh)
                        Image(systemName: "arrow.right")
                            .foreground(.onPrimaryHigh)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(.primaryDefault, cornerRadius: 4)
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                }
                .padding(.top, 24)
            }
            .padding(.vertical, 24)
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(.surfaceDefault, cornerRadius: 16)
        .padding(.horizontal, 14)
    }
}

#Preview {
    HMSPrebuiltDiagnosticsView().environmentObject(HMSUITheme())
}
