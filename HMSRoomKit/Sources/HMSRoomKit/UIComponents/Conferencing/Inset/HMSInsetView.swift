//
//  HMSInsetView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 03/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

struct HMSInsetView<Content>: View where Content : View {
    
    @GestureState private var dragState = DragState.none
    @State private var lastPosition: CGPoint = .zero
    @State private var currentPosition: CGPoint = .zero
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var isFirstTime = true
    
    enum DragState {
        case none
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .none, .dragging(translation: .zero):
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
    }
    
    @ViewBuilder let content: () -> Content
    let size: CGSize
    @Binding var isRefreshed: Bool
    let bottomOffset: CGFloat
    init(size: CGSize, bottomOffset: CGFloat, isRefreshed: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.size = size
        _isRefreshed = isRefreshed
        self.bottomOffset = bottomOffset
    }
    
    var body: some View {
        GeometryReader { geo in
            content()
                .position(currentPosition)
                .gesture(
                    DragGesture()
                        .updating($dragState, body: { value, state, _ in
                            state = .dragging(translation: value.translation)
                        })
                        .onChanged({ value in
                            self.currentPosition = self.getNewPosition(from: value.translation)
                        })
                        .onEnded({ value in
                            withAnimation {
                                self.currentPosition = self.getSnappedPosition(from: value.predictedEndTranslation, geo: geo)
                                self.lastPosition = self.currentPosition
                            }
                        })
                )
                .onAppear() {
                    self.currentPosition = getSnappedPosition(from: .init(width: 1000, height: 1000), geo: geo)
                    self.lastPosition = self.currentPosition
                }
                .onChange(of: isRefreshed) { _ in
                    moveIfRequired(geo: geo)
                }
                .onReceive(timer) { _ in
                    moveIfRequired(geo: geo)
                }
        }
    }
    
    private func moveIfRequired(geo: GeometryProxy) {
        
        guard case .none = dragState else { return }
        
        if !possiblePositions(geo: geo).contains(self.currentPosition) {
            withAnimation {
                self.currentPosition = getSnappedPosition(from: isFirstTime ? .init(width: 1000, height: 1000) : .zero, geo: geo)
                isFirstTime = false
                self.lastPosition = self.currentPosition
            }
        }
    }
    
    private func possiblePositions(geo: GeometryProxy) -> [CGPoint] {
        
        let snapMarginX: CGFloat = size.width/2 + 8
        
        let snapMarginYUp: CGFloat = size.height/2 + bottomOffset
        let snapMarginYDown: CGFloat = size.height/2 + 8
        
        let possiblePositions: [CGPoint] = [
            CGPoint(x: snapMarginX, y: snapMarginYDown),
            CGPoint(x: snapMarginX, y: geo.size.height - snapMarginYUp),
            CGPoint(x: geo.size.width - snapMarginX, y: snapMarginYDown),
            CGPoint(x: geo.size.width - snapMarginX,
                    y: geo.size.height - snapMarginYUp)
        ]
        return possiblePositions
    }
    
    private func getSnappedPosition(from translation: CGSize, geo: GeometryProxy) -> CGPoint {
        let newPosition = CGPoint(x: lastPosition.x + translation.width,
                                  y: lastPosition.y + translation.height)
        
        let possiblePositions: [CGPoint] = possiblePositions(geo: geo)
        
        // Find the closest corner to the new position
        var closestPosition = possiblePositions[0]
        var closestDistanceSquared = (newPosition.x - possiblePositions[0].x) * (newPosition.x - possiblePositions[0].x) +
        (newPosition.y - possiblePositions[0].y) * (newPosition.y - possiblePositions[0].y)
        for position in possiblePositions {
            let distanceSquared = (newPosition.x - position.x) * (newPosition.x - position.x) +
            (newPosition.y - position.y) * (newPosition.y - position.y)
            if distanceSquared < closestDistanceSquared {
                closestPosition = position
                closestDistanceSquared = distanceSquared
            }
        }
        
        return closestPosition
    }
    
    private func getNewPosition(from translation: CGSize) -> CGPoint {
        return CGPoint(x: lastPosition.x + translation.width,
                       y: lastPosition.y + translation.height)
    }
}


struct HMSInsetView_Previews: PreviewProvider {
    static var previews: some View {
#if Preview
        VStack {
            HMSInsetView(size: CGSize(width: 100, height: 100), bottomOffset: 75, isRefreshed: .constant(true)) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 100, height: 100)
            }
        }
#endif
    }
}
