//
//  HMSPrebuiltDiagnosticsConnectivityStepView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 05.06.2024.
//

import SwiftUI
import HMSSDK

struct HMSPrebuiltDiagnosticsConnectivityStepView: View {
    @ObservedObject var model: HMSPrebuiltDiagnosticsConnectivityStepModel
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        
        HMSPrebuiltDiagnosticsBackgroundStepView(title: "Connectivity Test", icon: "diag-connect", showsPrompt: model.shouldShowPrompt) {
            switch model.state {
            case .running:
                VStack(spacing: 0) {
                    HMSLoadingView {
                        Image(assetName: "progress-indicator")
                            .foreground(.primaryDefault)
                    }
                    .padding(.bottom, 24)
                    Text("Checking your connection...")
                        .font(.heading6Semibold20)
                        .foreground(.onSurfaceHigh)
                        .padding(.bottom, 8)
                    Text(model.subState.displayName)
                        .font(.body1Regular16)
                        .foreground(.onSurfaceMedium)
                }
            case .complete(let result):
                if result.state == .completed {
                    HMSPrebuiltDiagnosticsConnectivityResultView(model: result.toViewModel())
                } else {
                    if model.isShowingDetail {
                        HMSPrebuiltDiagnosticsConnectivityResultView(model: result.toViewModel())
                    } else {
                        HMSPrebuiltDiagnosticsConnectivityFailedView(isExpanded: $model.isShowingDetail)
                    }
                }
                    
            }
            
        } prompt: {
            if case let .complete(result) = model.state, result.state == .completed || model.isShowingDetail {
                VStack(spacing: 16) {
                    if let reportData = model.reportData() {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(assetName: "diag-download", renderingMode: .original)
                            Text("Download Test Report")
                                .font(.body2Semibold14)
                                .foreground(.onPrimaryHigh)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(.primaryDefault, cornerRadius: 4)
                        .allowsHitTesting(!isSharePresented)
                        .onTapGesture {
                            self.isSharePresented = true
                        }
                        .sheet(isPresented: $isSharePresented, onDismiss: {
                        }, content: {
                            ActivityViewController(activityItems: [reportData])
                        })
                    }
                    HStack(spacing: 8) {
                        Spacer()
                        Image(assetName: "diag-refresh", renderingMode: .original)
                        Text("Restart Test")
                            .font(.body2Semibold14)
                            .foreground(.onSurfaceHigh)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(.secondaryDefault, cornerRadius: 4)
                    .allowsHitTesting(!isSharePresented)
                    .onTapGesture {
                        model.startConnectivityCheck()
                    }
                }
                
            } else if case let .complete(result) = model.state, result.state != .completed {
                HStack {
                    Text("Try Again")
                        .font(.body2Semibold14)
                        .foreground(.onPrimaryHigh)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.primaryDefault, cornerRadius: 4)
                        .onTapGesture {
                            model.startConnectivityCheck()
                        }
                    Spacer()
                }
            }
            
            
        }.onAppear {
            model.startConnectivityCheck()
        }
    }
}

struct HMSPrebuiltDiagnosticsConnectivityResultView: View {
    var model: HMSPrebuiltDiagnosticsConnectivityResultModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(model.isComplete ? "Connectivity test has completed" : "Connectivity test has failed")
                .font(.body2Regular14)
                .foreground(.onSurfaceMedium)
            ForEach(model.items) { item in
                HMSPrebuiltDiagnosticsConnectivityResultItemView(model: item)
            }
        }
    }
}

struct HMSPrebuiltDiagnosticsConnectivityFailedView: View {
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Image(assetName: "diag-cross-xl", renderingMode: .original)

            VStack(alignment: .center, spacing: 8) {
                Text("Connectivity Test Failed")
                    .font(.heading6Semibold20)
                    .foreground(.onSurfaceHigh)
                Text("You can try again.")
                    .font(.body1Regular16)
                    .foreground(.onSurfaceMedium)
            }
            HStack {
                Image(assetName: "diag-eye", renderingMode: .original)
                Text("View detailed information")
                    .font(.captionRegular12)
                    .foreground(.primaryBright)
            }.onTapGesture {
                isExpanded = !isExpanded
            }
            
        }
    }
}

struct HMSPrebuiltDiagnosticsConnectivityResultItemView: View {
    @ObservedObject var model: HMSPrebuiltDiagnosticsConnectivityResultItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text(model.title)
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
                HStack(spacing: 8) {
                    Image(assetName: model.icon, renderingMode: .original)
                    Text(model.subtitle)
                        .font(.body2Semibold14)
                        .foreground(.onSurfaceHigh)
                    Spacer()
                }
            }
            HStack {
                Image(assetName: model.expanded ? "diag-eye-cross" : "diag-eye", renderingMode: .original)
                Text("\(model.expanded ? "Hide" : "View") detailed information")
                    .font(.captionRegular12)
                    .foreground(.primaryBright)
            }.onTapGesture {
                model.expanded = !model.expanded
            }
            
            if model.expanded {
                ForEach(model.sections) { section in
                    ForEach(section.items) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.title)
                                .font(.captionSemibold12)
                                .foreground(.onSurfaceMedium)
                            HStack(spacing: 8) {
                                if !item.icon.isEmpty {
                                    Image(assetName: item.icon, renderingMode: .original)
                                }
                                Text(item.subtitle)
                                    .font(.captionRegular12)
                                    .foreground(.onSurfaceHigh)
                                if !item.subtitleRight.isEmpty {
                                    Text(item.subtitleRight)
                                        .font(.captionRegular12)
                                        .foreground(.onSurfaceLow)
                                }
                            }
                            if !item.subtitle2.isEmpty {
                                Text(item.subtitle2)
                                    .font(.captionRegular12)
                                    .foreground(.onSurfaceLow)
                            }
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(.surfaceDefault, cornerRadius: 8)
    }
}

#Preview {
    HMSPrebuiltDiagnosticsConnectivityStepView(model: HMSPrebuiltDiagnosticsViewModel().connectivityStepModel())
        .environmentObject(HMSUITheme())
}


struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
