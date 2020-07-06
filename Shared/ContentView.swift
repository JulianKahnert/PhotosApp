//
//  ContentView.swift
//  Shared
//
//  Created by Julian Kahnert on 05.07.20.
//

import SwiftUI
import Photos

struct ContentView: View {
    
    @State var groupedAssets: [String: [PHAsset]] = Self.getAllAssets()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(groupedAssets.keys.sorted().reversed()), id: \.self) { key in
                    Section(header: Text(key)) {
                        WrappedPhotoLayout(assets: groupedAssets[key, default: []])
                     }
                }
            }
        }
    }
    
    private static func getAllAssets() -> [String: [PHAsset]] {
        let fetchOptions = PHFetchOptions()
        let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        var groupedAssets = [String: [PHAsset]]()
        result.enumerateObjects { (asset, index, _) in
            guard let creationDate = asset.creationDate else { return }
            let strDate = formatter.string(from: creationDate)
            
            groupedAssets[strDate, default: []].append(asset)
        }
        return groupedAssets
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
