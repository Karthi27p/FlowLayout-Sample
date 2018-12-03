//
//  CustomLayout.swift
//  FlowLayout
//
//  Created by Karthi on 30/05/17.
//  Copyright © 2017 Tringapps. All rights reserved.
//

import UIKit

class CustomLayoutAttributes: UICollectionViewLayoutAttributes {
    
    // 1
    var photoHeight: CGFloat = 0.0
    
    // 2
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with:zone) as! CustomLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3
    override func isEqual(_ object: Any?) -> Bool
    {
        if let attributes = object as? CustomLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

protocol customLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath: NSIndexPath, withWidth: CGFloat) -> CGFloat
}

class CustomLayout: UICollectionViewLayout {

    var delegate : customLayoutDelegate!
    var cellPadding  : CGFloat = 5.0
    var numberOfColumns = 2
    var cache = [CustomLayoutAttributes]()
    var contentHeight : CGFloat = 0.0
    var contentWidth : CGFloat
    {
        let inset = collectionView!.contentInset
        return (collectionView?.bounds)!.width-(inset.left+inset.right)
        
    }
    
    override func prepare() {
        // 1
        if cache.isEmpty {
            // 2
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // 3
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = NSIndexPath(item: item, section: 0)
                
                // 4
                let width = columnWidth - (cellPadding * 2)
                let photoHeight = delegate.collectionView(collectionView: collectionView!, heightForPhotoAtIndexPath: indexPath,
                                                          withWidth:width)
                //let annotationHeight = delegate.collectionView(collectionView: collectionView!,
                //                                           heightForPhotoAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding +  photoHeight  + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                // 5
                let attributes = CustomLayoutAttributes(forCellWith: indexPath as IndexPath)
                //attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column >= (numberOfColumns - 1) ? 0 : column+1
            }
        }
    }
    override var collectionViewContentSize:CGSize{
        return CGSize(width: contentWidth, height: contentHeight)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    override class var layoutAttributesClass: AnyClass {
        return CustomLayoutAttributes.self
    }
}
