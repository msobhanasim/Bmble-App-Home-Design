//
//  DynamicHeightCollectionView.swift
//  Datify-iOS
//
//  Created by Sobhan Asim on 13/10/2021.
//

import Foundation

import UIKit
class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
            collectionViewLayout.invalidateLayout()
        }
    }
    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
