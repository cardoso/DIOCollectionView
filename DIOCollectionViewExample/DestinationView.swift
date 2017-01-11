//
//  DestinationView.swift
//  DIOCollectionViewExample
//
//  Created by Matheus Martins on 11/28/16.
//  Copyright © 2016 matheusmcardoso. All rights reserved.
//

import UIKit
import DIOCollectionView

class DestinationCollectionView: DIOCollectionView, DIOCollectionViewDestination {
    
    func receivedDragWithDragInfo(_ dragInfo: DIODragInfo?, andDragState dragState: DIODragState) {
        switch(dragState) {
        case .began:
            self.visibleCells.forEach( { $0.isUserInteractionEnabled = false })
        case .ended:
            self.visibleCells.forEach( { $0.isUserInteractionEnabled = true })
        default:
            break
        }
    }

}

class DestinationView: UIView, DIOCollectionViewDestination {
    
    func receivedDragWithDragInfo(_ dragInfo: DIODragInfo?, andDragState dragState: DIODragState) {
        
        print(dragState)
        
        let selfLabel = self.subviews[0] as! UILabel
        let item = (dragInfo?.userData as? (Int, UIColor))!
        
        switch(dragState) {
        case .began:
            break
        case .ended:
            selfLabel.text = "\(item.0)"
            self.backgroundColor = item.1
        default:
            break
        }
    }
    
}

