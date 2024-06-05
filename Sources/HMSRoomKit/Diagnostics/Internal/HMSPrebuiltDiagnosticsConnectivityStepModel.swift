//
//  HMSPrebuiltDiagnosticsConnectivityStepModel.swift
//  HMSRoomKitPreview
//
//  Created by Dmitry Fedoseyev on 07.06.2024.
//

import Foundation
import HMSSDK

class HMSPrebuiltDiagnosticsConnectivityStepModel: ObservableObject {
    var sdk: HMSDiagnostics
    var region: String
    var onNextStep: (() -> Void)
    @Published var state: ConnectivityTestState = .running
    @Published var subState: HMSConnectivityCheckState = .starting
    @Published var isShowingDetail = false
    
    var shouldShowPrompt: Bool {
        if case .running = state {
            return false
        }
        return true
    }
    
    enum ConnectivityTestState {
        case running
        case complete(HMSConnectivityCheckResult)
    }

    internal init(sdk: HMSDiagnostics, region: String, onNextStep: @escaping (() -> Void)) {
        self.sdk = sdk
        self.region = region
        self.onNextStep = onNextStep
    }
    
    func reportData() -> Data? {
        guard case let .complete(result) = state else { return nil }
        return try? JSONEncoder().encode(result)
    }
    
    func startConnectivityCheck() {
        state = .running
        subState = .starting
        isShowingDetail = false
        
        sdk.startConnectivityCheck(region: region) { [weak self] state in
            self?.subState = state
        } completion: { [weak self] result in
            self?.state = .complete(result)
        }
    }
}

class HMSPrebuiltDiagnosticsConnectivityResultModel: ObservableObject {
    internal init(items: [HMSPrebuiltDiagnosticsConnectivityResultItem], isComplete: Bool) {
        self.items = items
        self.isComplete = isComplete
    }
    
    var items: [HMSPrebuiltDiagnosticsConnectivityResultItem]
    var isComplete: Bool
}

class HMSPrebuiltDiagnosticsConnectivityResultItem: ObservableObject, Identifiable {
    @Published var expanded = false
    
    var id: String {
        title
    }
    var title: String
    var subtitle: String
    var icon: String
    var sections: [HMSPrebuiltDiagnosticsConnectivityResultDetailSection]
    
    internal init(title: String, subtitle: String, icon: String, sections: [HMSPrebuiltDiagnosticsConnectivityResultDetailSection]) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.sections = sections
    }
}

struct HMSPrebuiltDiagnosticsConnectivityResultDetailSection: Identifiable {
    var id: String {
        title
    }
    var title: String
    var items: [HMSPrebuiltDiagnosticsConnectivityResultDetailItem]
}

struct HMSPrebuiltDiagnosticsConnectivityResultDetailItem: Identifiable {
    var id: String {
        title
    }
    
    var title: String
    var icon: String
    var subtitle: String
    var subtitleRight: String
    var subtitle2: String
}

extension HMSConnectivityCheckState {
    var displayName: String {
        switch self {
        case .starting:
            "Fetching Init..."
        case .initFetched:
            "Connecting to signalling server..."
        case .signallingConnected:
            "Establishing ICE connection..."
        case .iceEstablished:
            "Testing media capture..."
        case .mediaCaptured:
            "Testing media publish..."
        case .mediaPublished:
            "Media published"
        case .completed:
            "Complete"
        @unknown default:
            ""
        }
    }
}

extension HMSConnectivityCheckResult {
    func toViewModel() -> HMSPrebuiltDiagnosticsConnectivityResultModel {
        let items = [signallingReport.toViewModel(), mediaServerReport.toViewModel(state: state)]
            .compactMap { $0 }
            .flatMap { $0 }
        return HMSPrebuiltDiagnosticsConnectivityResultModel(items: items, isComplete: state == .completed)
    }
}

extension HMSSignallingReport {
    func toViewModel() -> [HMSPrebuiltDiagnosticsConnectivityResultItem] {
        
        var items = [HMSPrebuiltDiagnosticsConnectivityResultDetailItem]()
        
        let gateway = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Signalling Gateway", icon: isInitConnected ? "diag-tick-small" : "diag-cross-small", subtitle: isInitConnected ? "Reachable" : "Not Reachable", subtitleRight: "", subtitle2: "")
        items.append(gateway)
        
        if let websocketUrl = websocketUrl {
            let websocket = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Websocket URL", icon: "diag-link", subtitle: websocketUrl, subtitleRight: "", subtitle2: "")
            items.append(websocket)
        }
        
        let section = HMSPrebuiltDiagnosticsConnectivityResultDetailSection(title: "", items: items)
        let item = HMSPrebuiltDiagnosticsConnectivityResultItem(title: "Signalling server connection test", subtitle: isConnected ? "Connected" : "Failed", icon: isConnected ? "diag-tick-large" : "diag-cross-large", sections: [section])
        
        return [item]
    }
}

extension HMSMediaServerReport {
    func toViewModel(state: HMSConnectivityCheckState) -> [HMSPrebuiltDiagnosticsConnectivityResultItem] {
        
        var items = [HMSPrebuiltDiagnosticsConnectivityResultDetailItem]()
        
        let isCaptured = state.rawValue >= HMSConnectivityCheckState.mediaCaptured.rawValue
        let captured = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Media Captured", icon: isCaptured ? "diag-tick-small" : "diag-cross-small", subtitle: isPublishICEConnected ? "Yes" : "No", subtitleRight: "", subtitle2: "")
        items.append(captured)
        
        
        let isPublished = state.rawValue >= HMSConnectivityCheckState.mediaPublished.rawValue
        let published = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Media Published", icon: isPublished ? "diag-tick-small" : "diag-cross-small", subtitle: isSubscribeICEConnected ? "Yes" : "No", subtitleRight: "", subtitle2: "")
        items.append(published)
        
        if let connectionQualityScore = connectionQualityScore {
            let score = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Connection Quality Score (CQS)", icon: "diag-tick-small", subtitle: "\(connectionQualityScore)", subtitleRight: "out of 5", subtitle2: "")
            items.append(score)
        }
        
        let section = HMSPrebuiltDiagnosticsConnectivityResultDetailSection(title: "", items: items)
        let item = HMSPrebuiltDiagnosticsConnectivityResultItem(title: "Media server connection test", subtitle: isSubscribeICEConnected && isPublishICEConnected ? "Connected" : "Failed", icon: isSubscribeICEConnected && isPublishICEConnected ? "diag-tick-large" : "diag-cross-large", sections: [section])
        
        return [item] + statsItems()
    }
    
    func statsItems() -> [HMSPrebuiltDiagnosticsConnectivityResultItem] {
        guard let stats = stats else { return [] }
        
        var items = [HMSPrebuiltDiagnosticsConnectivityResultDetailItem]()
        
        let bytesReceived = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Bytes Received", icon: "", subtitle: "\(stats.audio.bytesReceived)", subtitleRight: "", subtitle2: "")
        items.append(bytesReceived)
        
        let packetLoss = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Packets Lost", icon: "", subtitle: "\(stats.audio.packetsLost)", subtitleRight: "", subtitle2: "")
        items.append(packetLoss)
        
        let packetReceived = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Packets Received", icon: "", subtitle: "\(stats.audio.packetsReceived)", subtitleRight: "", subtitle2: "")
        items.append(packetReceived)
        
        let formattedBitrateSent = String(format: "%.2f", stats.audio.bitrateSent)
        let bitrate = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Bitrate Sent", icon: "", subtitle: "\(formattedBitrateSent)", subtitleRight: "", subtitle2: "")
        items.append(bitrate)
        
        let formattedBitrateReceived = String(format: "%.2f", stats.audio.bitrateReceived)
        let bitrateReceived = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Bitrate Received", icon: "", subtitle: "\(formattedBitrateReceived)", subtitleRight: "", subtitle2: "")
        items.append(bitrateReceived)
        
        let rtt = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Round-Trip Time (RTT)", icon: "", subtitle: "\(stats.audio.roundTripTime)", subtitleRight: "", subtitle2: "")
        items.append(rtt)
        
        let section = HMSPrebuiltDiagnosticsConnectivityResultDetailSection(title: "", items: items)
        let audioItem = HMSPrebuiltDiagnosticsConnectivityResultItem(title: "Audio", subtitle: "Received", icon: "diag-tick-large", sections: [section])
        
        items.removeAll()
        
        let bytesReceivedVideo = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Bytes Received", icon: "", subtitle: "\(stats.video.bytesReceived)", subtitleRight: "", subtitle2: "")
        items.append(bytesReceivedVideo)
        
        let packetLossVideo = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Packets Lost", icon: "", subtitle: "\(stats.video.packetsLost)", subtitleRight: "", subtitle2: "")
        items.append(packetLossVideo)
        
        let packetReceivedVideo = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Packets Received", icon: "", subtitle: "\(stats.video.packetsReceived)", subtitleRight: "", subtitle2: "")
        items.append(packetReceivedVideo)
        
        let formattedBitrateSentVideo = String(format: "%.2f", stats.video.bitrateSent)
        let bitrateVideo = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Bitrate Sent", icon: "", subtitle: "\(formattedBitrateSentVideo)", subtitleRight: "", subtitle2: "")
        items.append(bitrateVideo)
        
        let formattedBitrateReceivedVideo = String(format: "%.2f", stats.video.bitrateReceived)
        let bitrateReceivedVideo = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Bitrate Received", icon: "", subtitle: "\(formattedBitrateReceivedVideo)", subtitleRight: "", subtitle2: "")
        items.append(bitrateReceivedVideo)
        
        let rttVideo = HMSPrebuiltDiagnosticsConnectivityResultDetailItem(title: "Round-Trip Time (RTT)", icon: "", subtitle: "\(stats.video.roundTripTime)", subtitleRight: "", subtitle2: "")
        items.append(rttVideo)
        
        let sectionVideo = HMSPrebuiltDiagnosticsConnectivityResultDetailSection(title: "", items: items)
        let videoItem = HMSPrebuiltDiagnosticsConnectivityResultItem(title: "Video", subtitle: "Received", icon: "diag-tick-large", sections: [sectionVideo])
        
        return [audioItem, videoItem]
    }
}
