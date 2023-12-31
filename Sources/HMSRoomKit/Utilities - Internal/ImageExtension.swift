//
//  ImageExtension.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 30/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

extension Image {
    init(assetName: String, renderingMode: TemplateRenderingMode = .template) {
#if Development || Preview
        self.init(assetName, bundle: .main)
#else
        self.init(assetName, bundle: .module)
#endif
        self = self.renderingMode(renderingMode)
    }
}

extension Color {
    init(assetName: String) {
#if Development || Preview
        self.init(assetName, bundle: .main)
#else
        self.init(assetName, bundle: .module)
#endif
    }
}
