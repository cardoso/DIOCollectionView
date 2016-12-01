//
//  DIOCollectionView.swift
//  DIOCollectionViewExample
//
//  Created by Matheus Martins on 11/28/16.
//  Copyright © 2016 matheusmcardoso. All rights reserved.
//

import UIKit

class DIODragInfo {
    
    var userData: Any?
    var sender: DIOCollectionView
    var indexPath: IndexPath
    
    init(withUserData userData: Any?, andIndexPath indexPath: IndexPath, andSender sender: DIOCollectionView) {
        
        self.userData = userData
        self.indexPath = indexPath
        self.sender = sender
    }
}

enum DIODragState {
    // user long pressed inside cell
    case began(location: CGPoint)
    
    // user entered a view
    case entered(location: CGPoint)
    
    // user moved
    case moved(location: CGPoint)
    
    // user lifted finger
    case ended(location: CGPoint)
    
    // user left a view
    case left(location: CGPoint)
    
    // system cancelled
    case cancelled(location: CGPoint)
}



protocol DIOCollectionViewDelegate: class {
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, draggedItemAtIndexPath indexPath: IndexPath, withDragState dragState: DIODragState)
}

protocol DIOCollectionViewDestination {
    
    func receivedDragWithDragInfo(_ dragInfo: DIODragInfo?, andDragState dragState: DIODragState)
}

class DIOCollectionView: UICollectionView {
    
    weak var dioDelegate: DIOCollectionViewDelegate?
    weak var dioDataSource: DIOCollectionViewDataSource?
    
    var longPress: UILongPressGestureRecognizer?
    
    // if user started dragging
    var beganDragging = false
    
    // dragInfo to send to destination
    var dragInfo: DIODragInfo?
    
    // fake view for dragging
    var dragView: UIView?
    
    // current destination
    var lastDestinationView: UIView?
    
    // touch offset from center of dragged cell
    var dragOffset = CGPoint.zero
    
    // allow drag and drop in same view
    var allowFeedback = false
    
    // indexPath being dragged
    var dragIndexPath = IndexPath(item: -1, section: -1)
    
    // Initialize
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        installLongPress()
    }
    
    // Install gesture recognizer for long press
    func installLongPress() {
        
        if self.longPress == nil {
            self.longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            self.longPress?.minimumPressDuration = 0.2
            
            self.addGestureRecognizer(self.longPress!)
        }
    }
    
    
    // Called when user does a long press
    func handleLongPress(longPress: UILongPressGestureRecognizer) {
        
        let location = longPress.location(in: self)
        
        // handle long press by state
        switch(longPress.state) {
        case .began:
            startDragAtLocation(location)
        case .changed:
            updateDragAtLocation(location)
        case .ended:
            endDragAtLocation(location)
            self.beganDragging = false
        case .cancelled:
            cancelDragAtLocation(location)
            self.beganDragging = false
            break
        default:
            break
        }
    }
    
    func startDragAtLocation(_ location: CGPoint) {
        
        guard let dataSource = self.dioDataSource else { return }
        
        // get indexPath of Item at drag location then get the cell
        guard let indexPath = self.indexPathForItem(at: location),
            isValidIndexPath(indexPath: indexPath) else { return }
        guard let cell = self.cellForItem(at: indexPath) else { return }
        
        // get dragInfo from dataSource
        self.dragInfo = DIODragInfo(
            withUserData: self.dioDataSource?.dioCollectionView(self, userDataForItemAtIndexPath: indexPath),
            andIndexPath: indexPath, andSender: self)
        
        // make a fake view and add to superview, hide real cell
        self.dragView = dataSource.dioCollectionView(self, viewForItemAtIndexPath: indexPath)
        self.dragView!.frame = self.convert(cell.frame, to: self.superview)
        self.dragView!.isUserInteractionEnabled = false // for hitTests
        self.superview!.addSubview(self.dragView!)
        
        // notify delegate
        self.dioDelegate?.dioCollectionView(self, draggedItemAtIndexPath: indexPath, withDragState: .began(location: location))
        
        // set beganDrag flag
        self.beganDragging = true
        
        // save indexPath
        self.dragIndexPath = indexPath
        
        //cell.isHidden = true
        
        // get offset from center of dragView
        self.dragOffset = CGPoint(x: dragView!.center.x - location.x, y: dragView!.center.y - location.y)
        
        // animate dragView
        
        let animations = dataSource.dioCollectionView(self, animationsForItemAtIndexPath: indexPath, withDragState: .began(location: location))
        UIView.animate(withDuration: animations.duration, animations: animations.animations)
        
    }
    
    func updateDragAtLocation(_ location: CGPoint) {
        
        if(!beganDragging) { return }
        
        
        guard let dataSource = self.dioDataSource else { return }
        
        // notify delegate
        self.dioDelegate?.dioCollectionView(self, draggedItemAtIndexPath: self.dragIndexPath, withDragState: .moved(location: location))
        
        // get fake view for dragging
        guard let dragView = self.dragView else { return }
        
        // set position of dragView to new location
        dragView.center = CGPoint(x: location.x + self.dragOffset.x, y: location.y + self.dragOffset.y)
        
        // dragState to be figured out later
        var dragState = DIODragState.moved(location: location)
        
        // get view behind dragView
        let hitTestView = self.superview?.hitTest(dragView.center, filter: destinationFilter)
        
        if let destination = hitTestView as? DIOCollectionViewDestination { // hit a destination
            guard let destinationView = destination as? UIView else { return }
            
            // get location inside destinationView
            let location = self.superview!.convert(dragView.center, to: destinationView)
            
            // figure out state and send event to destination
            // REFACTOR HINT: get a brain transplant
            
            if self.lastDestinationView != nil {
                
                if destinationView != self.lastDestinationView {
                    
                    // send events
                    let lastDestination = self.lastDestinationView as? DIOCollectionViewDestination
                    lastDestination?.receivedDragWithDragInfo(self.dragInfo, andDragState: .left(location: location))
                    destination.receivedDragWithDragInfo(self.dragInfo, andDragState: .entered(location: location))
                    
                    dragState = .entered(location: location)
                } else {
                    
                    // send events
                    destination.receivedDragWithDragInfo(self.dragInfo, andDragState: .moved(location: location))
                    
                    dragState = .moved(location: location)
                }
            } else {
                
                // send events
                destination.receivedDragWithDragInfo(self.dragInfo, andDragState: .entered(location: location))
                
                dragState = .entered(location: location)
            }
            
            self.lastDestinationView = destinationView
            

        } else {
            
            let lastDestinationView = (self.lastDestinationView as? DIOCollectionViewDestination)
            lastDestinationView?.receivedDragWithDragInfo(self.dragInfo, andDragState: .left(location: location))
            self.lastDestinationView = nil
            
            dragState = .left(location: location)
        }
        
        // animate
        
        let animations = dataSource.dioCollectionView(self, animationsForItemAtIndexPath: dragIndexPath, withDragState: dragState)
        UIView.animate(withDuration: animations.duration, animations: animations.animations)
    }
    
    func endDragAtLocation(_ location: CGPoint) {
        
        if(!beganDragging) { return }
        
        guard let dataSource = self.dioDataSource else { return }
        
        // notify delegate
        self.dioDelegate?.dioCollectionView(self, draggedItemAtIndexPath: self.dragIndexPath, withDragState: .ended(location: location))
        
        // get fake view for dragging
        guard let dragView = self.dragView else { return }
        
        // get view behind dragView
        guard let destination = self.superview?.hitTest(dragView.center, filter: destinationFilter) as? DIOCollectionViewDestination else { return }
        guard let destinationView = destination as? UIView else { return }
        
        // get location inside destinationView
        let location = self.superview!.convert(dragView.center, to: destinationView)
        
        // send event to destination
        destination.receivedDragWithDragInfo(self.dragInfo, andDragState: .ended(location: location))
        
        // animate
        
        let animations = dataSource.dioCollectionView(self, animationsForItemAtIndexPath: dragIndexPath, withDragState: .ended(location: location))
        UIView.animate(withDuration: animations.duration, animations: animations.animations) {
            _ in
            self.dragView?.removeFromSuperview()
        }
    }
    
    func cancelDragAtLocation(_ location: CGPoint) {
        
        if(!beganDragging) { return }
        
        // notify delegate
        self.dioDelegate?.dioCollectionView(self, draggedItemAtIndexPath: self.dragIndexPath, withDragState: .cancelled(location: location))
        
        // get fake view for dragging
        guard let dragView = self.dragView else { return }
        
        // get view behind dragView
        guard let destination = self.superview?.hitTest(dragView.center, filter: destinationFilter) as? DIOCollectionViewDestination else { return }
        guard let destinationView = destination as? UIView else { return }
        
        // get location inside destinationView
        let location = self.superview!.convert(dragView.center, to: destinationView)
        
        // send event to destination
        destination.receivedDragWithDragInfo(self.dragInfo, andDragState: .cancelled(location: location))
    }
    
    // destination view filter
    func destinationFilter(view: UIView) -> Bool {
        
        if view as? DIOCollectionViewDestination != nil {
            
            if(self.allowFeedback) {
                
                return true
            } else {
                
                return view != self
            }
        }
        
        return false
    }
    
    // is indexPath valid
    func isValidIndexPath(indexPath: IndexPath) -> Bool {
        
        return indexPath.section < self.numberOfSections &&
            indexPath.row < self.numberOfItems(inSection: indexPath.section)
    }
}
