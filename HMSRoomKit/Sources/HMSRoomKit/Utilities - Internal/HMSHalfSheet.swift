//
//  HMSHalfSheet.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 03/07/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSInnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HMSSheet<Content>: View where Content : View {
    
    let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        HalfSheet(height: sheetHeight) {
            Group {
                if #available(iOS 16.0, *) {
                    content
                }
                else {
                    GeometryReader {_ in
                        content
                    }
                }
            }
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(key: HMSInnerHeightPreferenceKey.self, value: geometry.size.height)
                }
            }
            .onPreferenceChange(HMSInnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(.surfaceDim, cornerRadius: 8.0, ignoringEdges: .all)
        }
    }
}

struct HMSSheet_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        Text("Sheet")
            .sheet(isPresented: .constant(true), content: {
                HMSSheet {
                    Text("Content")
                }
                
            })
            .environmentObject(HMSUITheme())
#endif
    }
}


private struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {
    
    private let content: Content
    var height: CGFloat
    
    @inlinable init(height: CGFloat, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.height = height
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        let sheet = HalfSheetController(rootView: content)
        sheet.height = height
        updateIndent(sheet)
        return sheet
    }
    
    func updateUIViewController(_ uiViewController: HalfSheetController<Content>, context: Context) {
        uiViewController.height = height
        updateIndent(uiViewController)
    }
    
    func updateIndent(_ uiViewController: HalfSheetController<Content>) {
        if let presentation = uiViewController.sheetPresentationController {
            if #available(iOS 16.0, *) {
                presentation.detents = [.custom { _ in
                    self.height
                }]
            } else {
                // Fallback on earlier versions
                presentation.detents = [.medium(), .large()]
            }
            presentation.prefersGrabberVisible = true
            presentation.largestUndimmedDetentIdentifier = .medium
        }
    }
}

private class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    
    var height: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
