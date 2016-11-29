//
//  UIView+Extensions.swift
//  DIOCollectionViewExample
//
//  Created by Matheus Martins on 11/28/16.
//  Copyright © 2016 matheusmcardoso. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func hitTest(_ point: CGPoint, filter: (UIView) -> Bool) -> UIView? {
        
        var view = self
        var point = point
        
        
        if let targetView = view.hitTest(point, with: nil) {
            
            if filter(targetView) {
                return targetView
            } else {
                if view.superview == nil {
                    return nil
                }
                
                point = view.convert(point, to: view.superview!)
                view = view.superview!
                
                return nil//view.hitTest(point, filter: filter)
            }
            
        } else {
            return nil
        }
    }
}
