//
//  LibImage.swift
//  PhotosApp
//
//  Created by Julian Kahnert on 05.07.20.
//

import SwiftUI
import Photos

extension LibImage {
    class RefrenceTest {
        let id: String
        
        init(_ id: String) {
            self.id = id
        }
        
        deinit {
            // this should be called when the view gets released, right!?
            print("Releasing view with asset id: \(id)")
        }
    }
}

struct LibImage: View {

    let asset: PHAsset
    @State var image: CGImage? = nil
    private let tmp: RefrenceTest
    
    init(asset: PHAsset) {
        self.asset = asset
        self.tmp = RefrenceTest(asset.localIdentifier)
    }
    
    var body: some View {
        content
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    private var content: Image {
        if let image = image {
            return Image(image, scale: 1, label: Text(asset.localIdentifier))
        } else {
            DispatchQueue.global().async {
                self.fetchImage()
            }
            return Image(systemName: "cloud")
        }
    }

    private func fetchImage() {
        
        // fetch full image
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true
        let resource = PHAssetResource.assetResources(for: asset).first!

        var currentData = Data()
        PHAssetResourceManager.default().requestData(for: resource,
                                                     options: options) { newData in
            currentData.append(newData)
        } completionHandler: { error in
            guard error == nil,
                  let rawImage = CGImage.create(from: currentData) else { return }
            DispatchQueue.main.async {
                self.image = rawImage
            }
        }

        // fetch small image
//        let options = PHImageRequestOptions()
//        PHImageManager.default().requestImage(for: asset,
//                                              targetSize: .init(width: 300, height: 300),
//                                              contentMode: .aspectFit,
//                                              options: options) { image, _ in
//            guard let rawImage = image?.cgImage else { return }
//
//            DispatchQueue.main.async {
//                self.image = rawImage
//            }
//        }
    }
}

fileprivate extension CGImage {
    static func create(from data: Data) -> CGImage? {
        #if os(macOS)
        return NSImage(data: data)?.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        #else
        return UIImage(data: data)?.cgImage
        #endif
    }
}

struct LibImage_Previews: PreviewProvider {
    static var previews: some View {
        LibImage(asset: PHAsset())
    }
}
