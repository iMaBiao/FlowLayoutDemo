//
//  ViewController.swift
//  FlowLayout
//
//  Created by Telit on 2018/7/13.
//  Copyright © 2018年 iMaBiao. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDataSource ,MBFlowLayoutDelegate {

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        
        let layout = MBFlowLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        
        let tag = 10
        var label = cell.contentView.viewWithTag(tag) as? UILabel
        if label == nil {
            label = UILabel()
            label?.tag = tag
            cell.contentView.addSubview(label!)
        }
        
        label?.text = "\(indexPath.item)"
        label?.sizeToFit()
        cell.backgroundColor = UIColor.orange
        
        return cell
    }
    
    //MARK: --- MBFlowLayoutDelegate ---
    func flowLayoutHeightForItemAtIndex(_ flowLayout: MBFlowLayout, _ index: Int, _ itemWidth: CGFloat) -> CGFloat {
        
        //真实的高度
        let realH : CGFloat  = CGFloat(50 + arc4random_uniform(100))
        let realW : CGFloat  = CGFloat(50 + arc4random_uniform(100))
     
        //按宽高比缩小
        return itemWidth * realH / realW;
    }
    
    func numOfRowMarginInFlowLayout(_ flowLayout: MBFlowLayout) -> CGFloat {
        return 10
    }
    
    func columnCountInFlowLayout(_ flowLayout: MBFlowLayout) -> CGFloat {
        return 3
    }
    
    func columnMarginInFlowLayout(_ flowLayout: MBFlowLayout) -> CGFloat {
        return 10
    }
    
    func edgeInsetInFlowLayout(_ flowLayout: MBFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

}

