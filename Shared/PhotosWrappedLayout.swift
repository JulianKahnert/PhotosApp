//
//  PhotosWrappedLayout.swift
//  PhotosApp
//
//  Created by Julian Kahnert on 05.07.20.
//

import SwiftUI
import Photos

struct WrappedPhotoLayout: View {
    
    let assets: [PHAsset]
    @State var itemsInRow: Int = 3
    
    private let spacing: CGFloat = 8
    
    var body: some View {
        ForEach(0...assets.count / itemsInRow, id: \.self) { rowIndex in
            HStack(spacing: spacing) {
                getViewFor(row: rowIndex, column: 0)
                getViewFor(row: rowIndex, column: 1)
                getViewFor(row: rowIndex, column: 2)
            }
            // fix fatalError: https://developer.apple.com/forums/thread/650605
            .id(UUID())
        }
    }
    
    @ViewBuilder
    private func getViewFor(row rowIndex: Int, column columnIndex: Int) -> some View {
        let itemIndex = rowIndex * 3 + columnIndex
        if itemIndex < self.assets.count {
            LibImage(asset: self.assets[itemIndex])
        } else {
            EmptyView()
        }
    }
}

struct WrappedPhotoLayout_Previews: PreviewProvider {
    static var previews: some View {
        WrappedPhotoLayout(assets: [])
    }
}
