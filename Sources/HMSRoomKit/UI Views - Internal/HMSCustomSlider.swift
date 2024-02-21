//
//  HMSCustomSlider.swift
//  HMSRoomKitPreview
//
//  Based on code by ggaljjak, https://github.com/GGJJack/SwiftUICustomSlider
//

import SwiftUI

struct HMSSeekBarView: View {
    @EnvironmentObject var currentTheme: HMSUITheme
    
    @Binding var progress: CGFloat
    
    var onProgressStart: (() -> Void)? = nil
    var onProgressEnd: (() -> Void)? = nil
    
    var body: some View {
        HMSCustomSlider($progress, max: 1).trackSize(4).cornerRadius(0).activeTrack(AnyView(currentTheme.colorTheme.primaryDefault)).inactiveTrack(AnyView(Color.init(white: 1.0, opacity: 0.25))).indicator(AnyView(Circle().fill(currentTheme.colorTheme.primaryDefault).frame(width: 12, height: 12, alignment: .center))).onStartProgress { _ in
            onProgressStart?()
        }.onEndProgress { _ in
            onProgressEnd?()
        }
    }
    
    public func onStartProgress(_ listener: (() -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressStart = listener
        return mySelf
    }
    
    public func onEndProgress(_ listener: (() -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressEnd = listener
        return mySelf
    }
}

public struct HMSCustomSlider: View {
    public enum ValueIndicatorPosition {
        case top(offset: CGFloat)
        case bottom(offset: CGFloat)
        case center
    }

    private var progress: Binding<CGFloat>
    private var max: Binding<CGFloat>
    
    private var trackHeight: CGFloat = 5
    private var cornerRadius: CGFloat? = 5
    private var step: CGFloat? = nil
    
    private var activeTrack: AnyView = AnyView(Color.blue)
    private var inactiveTrack: AnyView = AnyView(Color.gray)
    private var indicator: AnyView? = AnyView(Circle().fill(Color.white).shadow(radius: 3).frame(width: 20, height: 20, alignment: .center))
    private var valueIndicator: AnyView? = nil
    private var valueIndicatorPosition: ValueIndicatorPosition = .top(offset: 2)
    private var isEnabled: Bool = true
    
    private var onProgressStart: ((CGFloat) -> Void)? = nil
    private var onProgressChange: ((CGFloat) -> Void)? = nil
    private var onProgressEnd: ((CGFloat) -> Void)? = nil
    
    @State private var indicatorFrame: CGSize = .zero
    @State private var valueIndicatorFrame: CGSize = .zero
    @State private var isDragging: Bool = false
    
    public init(_ progress: Binding<CGFloat>, max: Binding<CGFloat> = Binding.constant(100)) {
        self.progress = progress
        self.max = max
    }
    
    public init(_ progress: Binding<CGFloat>, max: CGFloat) {
        self.progress = progress
        self.max = Binding.constant(max)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                inactiveTrack
                    .frame(width: geo.size.width, height: trackHeight, alignment: .center)
                    .cornerRadius(cornerRadius ?? 0)
                activeTrack
                    .frame(width: geo.size.width * (progress.wrappedValue / max.wrappedValue), height: trackHeight, alignment: .center)
                    .cornerRadius(cornerRadius ?? 0)
                if let view = indicator {
                    ChildSizeReader(size: $indicatorFrame) {
                        view.offset(
                            x: geo.size.width * (progress.wrappedValue / max.wrappedValue) - indicatorFrame.width,
                            y: 0
                        )
                    }
                }
                if let view = valueIndicator {
                    ChildSizeReader(size: $valueIndicatorFrame) {
                        view.offset(
                            x: geo.size.width * (progress.wrappedValue / max.wrappedValue) - valueIndicatorFrame.width / 2,
                            y: getValueIndicatorFrame()
                        )
                    }
                }
            }
            .frame(width: geo.size.width, alignment: .leading)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        updateProgress(value: value, geo: geo)
                    })
                    .onEnded({ value in
                        endProgress(value: value, geo: geo)
                    })
            )
        }
        .frame(height: Swift.max(indicatorFrame.height, trackHeight), alignment: .top)
    }
    
    private func getValueIndicatorFrame() -> CGFloat {
        switch valueIndicatorPosition {
        case .center:
            return 0
        case .top(let offset):
            return -valueIndicatorFrame.height - offset
        case .bottom(let offset):
            return valueIndicatorFrame.height + offset
        }
    }
    
    private func updateProgress(value: DragGesture.Value, geo: GeometryProxy) {
        if !isEnabled { return }
        var percent = (value.location.x / geo.size.width)
        if percent < 0 {
            percent = 0
        } else if percent > 1 {
            percent = 1
        }
        var progress = max.wrappedValue * percent
        //print("[Drag]Width : \(geo.size.width), Touch : \(value.location.x), Progress : \(progress), Percent : \(percent)")
        if let step = step {
            let quotient = Int(progress / step)
            let remainder = progress.remainder(dividingBy: step)
            let adder = remainder < step / 2 ? 0 : step
            progress = CGFloat(quotient) * step + adder
        }
        if !isDragging {
            isDragging = true
            onProgressStart?(progress)
        }
        self.progress.wrappedValue = progress
        onProgressChange?(progress)
    }
    
    private func endProgress(value: DragGesture.Value, geo: GeometryProxy) {
        if !isEnabled { return }
        var percent = (value.location.x / geo.size.width)
        if percent < 0.01 {
            percent = 0
        } else if 0.99 < percent {
            percent = 1
        }
        var progress = max.wrappedValue * percent
        //print("[End]Width : \(geo.size.width), Touch : \(value.location.x), Progress : \(progress), Percent : \(percent)")
        if let step = step {
            let quotient = Int(progress / step)
            let remainder = progress.remainder(dividingBy: step)
            let adder = remainder < step / 2 ? 0 : step
            progress = CGFloat(quotient) * step + adder
        }
        self.progress.wrappedValue = progress
        onProgressEnd?(progress)
        self.isDragging = false
    }
    
    public func step(_ value: CGFloat?) -> Self {
        var mySelf = self
        mySelf.step = value
        return mySelf
    }

    public func indicator(_ view: AnyView?) -> Self {
        var mySelf = self
        mySelf.indicator = view
        return mySelf
    }
    
    public func valueIndicator(_ view: AnyView?) -> Self {
        var mySelf = self
        mySelf.valueIndicator = view
        return mySelf
    }
    
    public func valueIndicatorPosition(_ position: ValueIndicatorPosition) -> Self {
        var mySelf = self
        mySelf.valueIndicatorPosition = position
        return mySelf
    }
    
    public func activeTrack(_ view: AnyView) -> Self {
        var mySelf = self
        mySelf.activeTrack = view
        return mySelf
    }
    
    public func inactiveTrack(_ view: AnyView) -> Self {
        var mySelf = self
        mySelf.inactiveTrack = view
        return mySelf
    }
    
    public func trackSize(_ size: CGFloat) -> Self {
        var mySelf = self
        mySelf.trackHeight = size
        return mySelf
    }
    
    public func cornerRadius(_ value: CGFloat?) -> Self {
        var mySelf = self
        mySelf.cornerRadius = value
        return mySelf
    }
    
    public func step(_ value: CGFloat) -> Self {
        var mySelf = self
        mySelf.step = value
        return mySelf
    }
    
    public func onStartProgress(_ listener: ((CGFloat) -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressStart = listener
        return mySelf
    }
    
    public func onChangeProgress(_ listener: ((CGFloat) -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressChange = listener
        return mySelf
    }
    
    public func onEndProgress(_ listener: ((CGFloat) -> Void)?) -> Self {
        var mySelf = self
        mySelf.onProgressEnd = listener
        return mySelf
    }
    
    public func userInput(_ isUserInputable: Bool) -> Self {
        var mySelf = self
        mySelf.isEnabled = isUserInputable
        return mySelf
    }
}

public struct ChildSizeReader<Content: View>: View {
    var size: Binding<CGSize>
    let content: () -> Content
    
    public init(size: Binding<CGSize>, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size.wrappedValue = preferences
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    
    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}
