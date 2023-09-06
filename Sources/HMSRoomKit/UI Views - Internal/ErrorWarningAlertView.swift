//
//  EndSessionAlertView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 11/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct ErrorWarningAlertView: View {
    
    let errorText: String
    let onDismiss: ()->Void

    var body: some View {
        
        HStack {
            VStack {
                Image(assetName: "warning-icon")
                    .font(.heading6Semibold20)
                    .foreground(.errorDefault)
                
                Spacer(minLength: 0)
            }
            
            VStack(alignment: .leading) {
                Text("Error occurred")
                    .font(.subtitle2Semibold14)
                    .foreground(.onSurfaceHigh)
                
                Text(errorText)
                    .font(.body2Regular14)
                    .foreground(.onSurfaceMedium)
            }
            
            Spacer(minLength: 16)
            
            HMSXMarkView()
                .onTapGesture {
                    onDismiss()
                }
        }
        .padding(16)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .background(.surfaceDefault, cornerRadius: 12)
        .overlay {
            RoundedRectangle(cornerRadius: 12).stroke().foreground(.errorDefault)
        }
        .padding(5)
    }
}

struct ErrorWarningAlertView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        ErrorWarningAlertView(errorText: "You may have previously denied access to camera/mic", onDismiss: {})
            .environmentObject(HMSUITheme())
#endif
    }
}
