//
//  HMSPrebuiltDiagnosticsRegionStepView.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 10.06.2024.
//

import SwiftUI

struct HMSPrebuiltDiagnosticsRegionStepView: View {
    @Binding var region: String
    var onNextStep: (()->Void)
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 8) {
                Text("Pre-call Test")
                    .font(.heading5Semibold24)
                    .foreground(.onPrimaryHigh)
                Text("Make sure your devices and network are good to go, let's get started.")
                    .multilineTextAlignment(.center)
                    .font(.body1Regular16)
                    .foreground(.onSurfaceMedium)
            }
            
            VStack(spacing: 16) {
                Text("Select a region")
                    .font(.body1Regular16)
                    .foreground(.onSurfaceMedium)
                HStack(alignment:.center, spacing: 12) {
                    HMSPrebuiltDiagnosticsRegionView(text: "United States", isSelected: region == "us")
                        .onTapGesture {
                            region = "us"
                        }
                    HMSPrebuiltDiagnosticsRegionView(text: "Europe", isSelected: region == "eu")
                        .onTapGesture {
                            region = "eu"
                        }
                    HMSPrebuiltDiagnosticsRegionView(text:  "India", isSelected: region == "in")
                        .onTapGesture {
                            region = "in"
                        }
                }
            }
            
            Text("Get started")
                .font(.body2Semibold14)
                .foreground(.onPrimaryHigh)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.primaryDefault, cornerRadius: 4)
                .onTapGesture {
                   onNextStep()
                }
        }
    }
}

struct HMSPrebuiltDiagnosticsRegionView: View {
    var text: String
    var isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.body2Semibold14)
            .foreground(isSelected ? .onPrimaryHigh : .onSurfaceHigh)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isSelected ? .primaryDim : .clear, cornerRadius: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 4).stroke().foreground(isSelected ? .primaryDefault : .borderBright)
            )
    }
}

#Preview {
    HMSPrebuiltDiagnosticsRegionStepView(region: .constant("us"), onNextStep: {}).environmentObject(HMSUITheme()).background(.black)
}
