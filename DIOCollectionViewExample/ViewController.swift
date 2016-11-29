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
    
    let items1 = [(1, UIColor.red), (2, UIColor.red), (3, UIColor.red), (4, UIColor.red) , (5, UIColor.red) , (6, UIColor.red)]
    let items2 = [(1, UIColor.blue), (2, UIColor.blue), (3, UIColor.blue), (4, UIColor.blue) , (5, UIColor.blue) , (6, UIColor.blue)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.collectionView1.dioDataSource = self
        self.collectionView1.dioDelegate = self
        
        self.collectionView2.dioDataSource = self
        self.collectionView2.dioDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK - DIOCollectionViewDataSource
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, dragInfoForItemAtIndexPath indexPath: IndexPath) -> DIODragInfo {
        
        let cellData = ((dioCollectionView == collectionView1) ? items1 : items2)[indexPath.row]
        
        let dragInfo = DIODragInfo(withUserData: cellData)
        
        return dragInfo
    }
    
    // MARK - DIOCollectionViewDelegate
    
    func dioCollectionView(_ dioCollectionView: DIOCollectionView, startedDragAtIndexPath: IndexPath) {
        
    }
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ((collectionView == collectionView1) ? items1 : items2).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let label = cell.subviews[0].subviews[0] as! UILabel
        
        let item = ((collectionView == collectionView1) ? items1 : items2)[indexPath.row]
        
        label.text = "\(item.0)"
        cell.subviews[0].backgroundColor = item.1
        
        return cell
    }

}

