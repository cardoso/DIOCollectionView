//
//  ViewController.swift
//  DIOCollectionViewExample
//
//  Created by Matheus Martins on 11/28/16.
//  Copyright © 2016 matheusmcardoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, DIOCollectionViewDelegate, UICollectionViewDataSource, DIOCollectionViewDataSource {

    @IBOutlet weak var collectionView1: DIOCollectionView!
    @IBOutlet weak var collectionView2: DIOCollectionView!
    @IBOutlet weak var collectionView3: DIOCollectionView!
    
    
    var items1 = [(1, UIColor.red), (2, UIColor.red), (3, UIColor.red), (4, UIColor.red),
                  (5, UIColor.red) , (6, UIColor.red)]
    var items2 = [(1, UIColor.blue), (2, UIColor.blue), (3, UIColor.blue), (4, UIColor.blue),
                  (5, UIColor.blue) , (6, UIColor.blue)]
    var items3 = [(1, UIColor.green), (2, UIColor.green), (3, UIColor.green), (4, UIColor.green),
                  (5, UIColor.green) , (6, UIColor.green)]
    
    
    func itemsForCollectionView(collectionView: UICollectionView) -> [(Int, UIColor)] {
        if(collectionView == collectionView1) {
            return items1
        }
        
        if(collectionView == collectionView2) {
            return items2
        }
        
        if(collectionView == collectionView3) {
            return items3
        }
        
        return []
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.collectionView1.dioDataSource = self
        self.collectionView1.dioDelegate = self
        
        self.collectionView2.dioDataSource = self
        self.collectionView2.dioDelegate = self
        
        self.collectionView3.dioDataSource = self
        self.collectionView3.dioDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - DIOCollectionViewDataSource
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, dragInfoForItemAtIndexPath indexPath: IndexPath) -> DIODragInfo {
        
        let cellData = itemsForCollectionView(collectionView: dioCollectionView)[indexPath.row]
        
        let dragInfo = DIODragInfo(withUserData: cellData)
        
        return dragInfo
    }
    
    // MARK - DIOCollectionViewDelegate
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, draggedItemAtIndexPath indexPath: IndexPath, withDragState dragState: DIODragState) {
        
        if dioCollectionView == collectionView1 {
            switch(dragState) {
            case .ended:
                collectionView1.dragView?.removeFromSuperview()
            default:
                break
            }
        }
        
        if dioCollectionView == collectionView2 {
            switch(dragState) {
            case .ended:
                self.items2.remove(at: indexPath.row)
                self.collectionView2.deleteItems(at: [indexPath])
                
                collectionView2.dragView?.removeFromSuperview()
            default:
                break
            }
        }
        
        if dioCollectionView == collectionView3 {
            switch(dragState) {
            case .began:
                self.items3.remove(at: indexPath.row)
                self.collectionView3.deleteItems(at: [indexPath])
            case .ended:
                collectionView3.dragView?.removeFromSuperview()
            default:
                break
            }
        }
    }
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(itemsForCollectionView(collectionView: collectionView).count)
        return itemsForCollectionView(collectionView: collectionView).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let label = cell.subviews[0].subviews[0] as! UILabel
        
        let item = itemsForCollectionView(collectionView: collectionView)[indexPath.row]
        
        label.text = "\(item.0)"
        cell.subviews[0].backgroundColor = item.1
        
        return cell
    }

}

