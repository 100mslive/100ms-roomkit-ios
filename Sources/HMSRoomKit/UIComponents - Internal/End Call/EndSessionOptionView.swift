////
////  EndSessionOptionView.swift
////  HMSSDK
////
////  Created by Pawan Dixit on 11/07/2023.
////  Copyright © 2023 100ms. All rights reserved.
////
//
//import SwiftUI
//import Popovers
//
//struct EndSessionOptionView: View {
//    
//    @EnvironmentObject var currentTheme: HMSUITheme
//    
//    @Binding var isPresented: Bool
//    let completion: ()->Void
//    
//    @State var isAlertPresented = false
//    @State var expanding = false
//    
//    var body: some View {
//        HStack {
//            Image(assetName: "warning-icon")
//            Text("End Session")
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 16)
//        .foreground(.errorBright)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(.errorDim, cornerRadius: 8)
//        .background(.white.opacity(0.001))
//        .onTapGesture {
//            isAlertPresented.toggle()
//        }
//        .popover(
//            present: $isAlertPresented,
//            attributes: {
//                $0.blocksBackgroundTouches = true
//                $0.rubberBandingMode = .none
//                $0.position = .relative(
//                    popoverAnchors: [
//                        .center,
//                    ]
//                )
//                $0.presentation.animation = .easeOut(duration: 0.15)
//                $0.dismissal.mode = .none
//                $0.onTapOutside = {
//                    withAnimation(.easeIn(duration: 0.15)) {
//                        expanding = true
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        withAnimation(.easeOut(duration: 0.4)) {
//                            expanding = false
//                        }
//                    }
//                }
//            }
//        ) {
//            EndSessionAlertView(present: $isAlertPresented) {
//                isPresented = false
//                completion()
//            }
//            .environmentObject(currentTheme)
//        } background: {
//            Color.black.opacity(0.1)
//        }
//    }
//}
//
//struct EndSessionOptionView_Previews: PreviewProvider {
//    static var previews: some View {
//#if Preview
//        EndSessionOptionView(isPresented: .constant(true), completion: {})
//            .environmentObject(HMSUITheme())
//#endif
//    }
//}
