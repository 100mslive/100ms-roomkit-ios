//
//  HMSAsyncImage.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 25/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSAsyncImage: View {
    
    let url: URL
    
    @State private var isLoaded = false
    
    var body: some View {
        AsyncImage(url: url) { phase in
            
            if phase.error != nil {
                
            }
            else {
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .onAppear() {
                            isLoaded = true
                        }
                }
                else {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 32, height: 32)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 32, height: 32)
        .redacted(reason: isLoaded ? [] : .placeholder)
    }
}

struct HMSAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        HMSAsyncImage(url: URL(string: "https://picsum.photos/200")!)
    }
}
