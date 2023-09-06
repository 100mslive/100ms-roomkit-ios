////
////  EndSessionAlertView.swift
////  HMSSDK
////
////  Created by Pawan Dixit on 11/07/2023.
////  Copyright © 2023 100ms. All rights reserved.
////
//
//import SwiftUI
//
//struct EndSessionAlertView: View {
//    
//    @Binding var present: Bool
//    let completion: ()->Void
//
//    /// the initial animation
//    @State var scaled = true
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 32) {
//            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    Image(assetName: "warning-icon")
//                    Text("End Session")
//                }
//                .font(.heading6Semibold20)
//                .foreground(.errorDefault)
//                
//                Text("The session will end for everyone and all the activities will stop. You can’t undo this action.")
//                    .foreground(.onSurfaceMedium)
//                    .font(.body2Regular14)
//            }
//            
//            HStack {
//                Text("Cancel")
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 16)
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 8).stroke().foreground(.borderBright)
//                    }
//                    .font(.buttonSemibold16)
//                    .foreground(.onSurfaceHigh)
//                    .onTapGesture {
//                        present = false
//                    }
//                
//                Spacer(minLength: 0)
//                
//                Text("End Session")
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 16)
//                    .font(.buttonSemibold16)
//                    .foreground(.errorBrighter)
//                    .background(.errorDefault, cornerRadius: 8)
//                    .onTapGesture {
//                        present = false
//                        completion()
//                    }
//            }
//        }
//        .padding(24)
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//        .frame(maxWidth: .infinity)
//        .background(.surfaceDim, cornerRadius: 12)
//        .overlay {
//            RoundedRectangle(cornerRadius: 12).stroke().foreground(.errorDefault)
//        }
//        .popoverShadow(shadow: .system)
//        .opacity(scaled ? 0 : 1)
//        .onAppear {
//            withAnimation(.spring(
//                response: 0.4,
//                dampingFraction: 0.9,
//                blendDuration: 1
//            )) {
//                scaled = false
//            }
//        }
//    }
//}
//
//struct EndSessionAlertView_Previews: PreviewProvider {
//    static var previews: some View {
//#if Preview
//        EndSessionAlertView(present: .constant(true), completion: {})
//            .environmentObject(HMSUITheme())
//#endif
//    }
//}
