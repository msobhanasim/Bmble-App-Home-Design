//
//  UICollectionView+Extension.swift
//  Clout
//
//  Created by CP on 10/25/19.
//  Copyright © 2019 CP. All rights reserved.
//

import UIKit
import Foundation


public protocol LiquidLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat
    
     func collectionView(collectionView: UICollectionView, widthForCellAtIndexPath indexPath: IndexPath, height: CGFloat) -> CGFloat
}

public class LiquidCollectionViewLayout: UICollectionViewLayout {

    var delegate: LiquidLayoutDelegate!
    var cellPadding: CGFloat = 0.0
    var cellWidth: CGFloat = 150.0
    var cachedWidth: CGFloat = 0.0

    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentHeight: CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat {
        if let collectionView = collectionView {
            let insets = collectionView.contentInset
            return collectionView.bounds.width - (insets.left + insets.right)
        }
        return 0
    }
    fileprivate var numberOfItems = 0

    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override public func prepare() {
        guard let collectionView = collectionView else { return }

        let numberOfColumns = Int(contentWidth / cellWidth) // #3
        let totalSpaceWidth = contentWidth - CGFloat(numberOfColumns) * cellWidth
        let horizontalPadding = totalSpaceWidth / CGFloat(numberOfColumns + 1)
        let numberOfItems = collectionView.numberOfItems(inSection: 0)

        if (contentWidth != cachedWidth || self.numberOfItems != numberOfItems) { // #1
            cache = []
            contentHeight = 0
            self.numberOfItems = numberOfItems
        }

        if cache.isEmpty { // #2
            cachedWidth = contentWidth
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * cellWidth + CGFloat(column + 1) * horizontalPadding)
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)

            for row in 0 ..< numberOfItems {

                let indexPath = IndexPath(row: row, section: 0)

                
                let cellHeight = delegate.collectionView(collectionView: collectionView, heightForCellAtIndexPath: indexPath, width: cellWidth)
                
//                let cellwidth = delegate.collectionView(collectionView: collectionView, widthForCellAtIndexPath: indexPath, height: cellHeight)

                let height = cellPadding +  cellHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: height)
                let insetFrame = frame.insetBy(dx: 0, dy: cellPadding)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath) // #4
                attributes.frame = insetFrame // #5
                cache.append(attributes) // #6
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                if column >= (numberOfColumns - 1) {
                    column = 0
                } else {
                    column = column + 1
                }
            }
        }
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache { // #7
            if attributes.frame.intersects(rect) { // #8
                layoutAttributes.append(attributes) // #9
            }
        }
        return layoutAttributes
    }
}


//

protocol PinterestLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  // 1
  weak var delegate: PinterestLayoutDelegate?

  // 2
  private let numberOfColumns = 2
  private let cellPadding: CGFloat = 1

  // 3
  private var cache: [UICollectionViewLayoutAttributes] = []

  // 4
  private var contentHeight: CGFloat = 0

  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }

  // 5
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func prepare() {
    // 1
    guard
      cache.isEmpty == true,
      let collectionView = collectionView
      else {
        return
    }
    // 2
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffset: [CGFloat] = []
    for column in 0..<numberOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

    // 3
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)

      // 4
      let photoHeight = delegate?.collectionView(
        collectionView,
        heightForPhotoAtIndexPath: indexPath) ?? 180
      let height = cellPadding * 2 + photoHeight
      let frame = CGRect(x: xOffset[column],
                         y: yOffset[column],
                         width: columnWidth,
                         height: height)
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      // 5
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      cache.append(attributes)

      // 6
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] = yOffset[column] + height

      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}



class CustomSegue: UIStoryboardSegue {
    override func perform() {

        let src = self.source
        let dst = self.destination
        src.navigationController?.pushViewController(dst, animated: true)
    }
}
