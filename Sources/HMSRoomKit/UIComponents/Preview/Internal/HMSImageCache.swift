//
//  HMSImageCache.swift
//  HMSRoomKitPreview
//
//  Created by Pawan Dixit on 6/27/24.
//

import SwiftUI
import Combine

class ImageCache {
    private var cache = NSCache<NSURL, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
    
    static let shared = ImageCache()
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private let cache = ImageCache.shared
    
    func loadImage(from url: URL) {
        if let cachedImage = cache.image(for: url) {
            self.image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                if let image = $0 {
                    self?.cache.setImage(image, for: url)
                }
                self?.image = $0
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}


struct CachedAsyncImageView: View {
    @StateObject private var loader: ImageLoader
    private let url: URL
    
    let onTapGesture: (UIImage)->Void
    
    init(url: URL, onTapGesture: @escaping (UIImage)->Void) {
        self.url = url
        _loader = StateObject(wrappedValue: ImageLoader())
        self.onTapGesture = onTapGesture
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        onTapGesture(image)
                    }
            } else {
                ProgressView()
                    .frame(height: 80)
            }
        }
        .onAppear {
            loader.loadImage(from: url)
        }
    }
}
