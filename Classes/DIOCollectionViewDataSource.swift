//
//  DIOCollectionViewDataSource.swift
//  DIOCollectionViewExample
//
//  Created by Matheus Martins on 12/1/16.
//  Copyright © 2016 matheusmcardoso. All rights reserved.
//

import Foundation
import UIKit

public protocol DIOCollectionViewDataSource: class {
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, userDataForItemAtIndexPath indexPath: IndexPath) -> Any?
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, viewForItemAtIndexPath indexPath: IndexPath) -> UIView
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, frameForItemAtIndexPath indexPath: IndexPath) -> CGRect
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, animationsForItemAtIndexPath indexPath: IndexPath, withDragState dragState: DIODragState) -> (animations: () -> Void, duration: TimeInterval)
}

public extension DIOCollectionViewDataSource {
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, viewForItemAtIndexPath indexPath: IndexPath) -> UIView {
        
        guard let cell = dioCollectionView.cellForItem(at: indexPath) else {
            fatalError("Unexpected behavior: no cell at index path")
        }
        
        guard let view = cell.snapshotView(afterScreenUpdates: false) else {
            fatalError("Unexpected behavior: cannot snapshot view from cell")
        }
        
        return view
    }
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, frameForItemAtIndexPath indexPath: IndexPath) -> CGRect {
        
        guard let cell = dioCollectionView.cellForItem(at: indexPath) else {
            fatalError("Unexpected behavior: no cell at index path")
        }
        
        return dioCollectionView.convert(cell.frame, to: dioCollectionView.superview)
    }
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, animationsForItemAtIndexPath indexPath: IndexPath, withDragState dragState: DIODragState) -> (animations: () -> Void, duration: TimeInterval) {
        
        guard let view = dioCollectionView.dragView else { fatalError("Unexpected behavior: missing snapshot view") }
        
        var animations = {}
        
        switch(dragState) {
        case .began:
            animations = {
                view.alpha = 0.95
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        case .entered:
            animations = {
                view.alpha = 1.0
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        case .left:
            animations = {
                view.alpha = 0.95
                view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        case .ended:
            animations = {
                view.alpha = 1.0
                view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        default:
            break
        }
        
        return (animations: animations, duration: 0.2)
    }
    
}
