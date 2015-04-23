//
//  CellPagingCollectionLayout.swift
//  About Cal
//
//  Created by Cal on 4/15/15.
//  Copyright (c) 2015 Cal Stephens. All rights reserved.
//

import UIKit

class CellPagingLayout : UICollectionViewFlowLayout {
    
    var pageWidth : CGFloat = 0
    var previousPage : CGFloat = 0
    
    var enabled = true
    
    init(pageWidth: CGFloat) {
        super.init()
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.pageWidth = pageWidth
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enable", name: CONTENT_COLLECTION_SCROLL_END, object: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disable() {
        enabled = false
    }
    
    func enable() {
        enabled = true
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let newOffset = getNewOffsetForVelocity(velocity.x)
        return CGPointMake(newOffset, 0)
    }

    
    func getNewOffsetForVelocity(velocity: CGFloat) -> CGFloat {
        
        if velocity == 0.0 && !enabled {
            return previousPage
        }
        
        let currentOffset = collectionView!.contentOffset.x
        var newOffset : CGFloat
        
        if velocity > 0 {
            newOffset = ceil(currentOffset / pageWidth) * pageWidth
        }
        else if velocity < 0 {
            newOffset = floor(currentOffset / pageWidth) * pageWidth
        }
        else { //no velocity
            let distanceToPrevious = currentOffset - previousPage
            
            if distanceToPrevious > 0 {
                newOffset = ceil(currentOffset / pageWidth) * pageWidth
            }
            else if distanceToPrevious < 0 {
                newOffset = floor(currentOffset / pageWidth) * pageWidth
            }
            else {
                newOffset = previousPage
            }
        }
        
        if previousPage != newOffset { //pause all videos if view changes
            NSNotificationCenter.defaultCenter().postNotificationName(PAUSE_ALL_NOTIFICATION, object: nil)
        }
        previousPage = newOffset
        disable()
        return newOffset
    }
    
    
    
}