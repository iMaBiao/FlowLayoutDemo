//
//  MBFlowLayout.swift
//  FlowLayout
//
//  Created by Telit on 2018/7/13.
//  Copyright © 2018年 iMaBiao. All rights reserved.
//

import UIKit

@objc protocol MBFlowLayoutDelegate : class {
    
    //外部设置布局的高度（必选）
    func flowLayoutHeightForItemAtIndex(_ flowLayout: MBFlowLayout, _ index: Int , _ itemWidth: CGFloat) -> CGFloat
    
    //可选
    @objc optional func columnCountInFlowLayout(_ flowLayout: MBFlowLayout) -> CGFloat
    @objc optional func numOfRowMarginInFlowLayout(_ flowLayout: MBFlowLayout) -> CGFloat
    @objc optional func columnMarginInFlowLayout(_ flowLayout: MBFlowLayout) -> CGFloat
    @objc optional func edgeInsetInFlowLayout(_ flowLayout: MBFlowLayout) -> UIEdgeInsets
}


class MBFlowLayout: UICollectionViewLayout {

    weak var delegate : MBFlowLayoutDelegate?
    
    ///存放所有cell的布局属性
    lazy var attrsArray : [UICollectionViewLayoutAttributes] =  Array()
    ///存放每列最大的Y值
    lazy var columMaxHeights: [CGFloat] = Array()
    
    var columnCount: CGFloat {
        guard let count = delegate?.columnCountInFlowLayout!(self) else {
            return 3
        }
        return count
    }
    
    var edgeInsets: UIEdgeInsets {
        
        guard let edge = delegate?.edgeInsetInFlowLayout!(self)  else {
            return UIEdgeInsetsMake(10, 10, 10, 10)
        }
        return edge
    }
    
    var columnMargin: CGFloat {
        guard let margin = delegate?.columnMarginInFlowLayout!(self) else {
            return 10
        }
        return margin
    }
    var rowMargin: CGFloat {
        
        guard let margin = delegate?.numOfRowMarginInFlowLayout!(self) else {
            return 10
        }
        return margin
    }
    
    
    override func prepare() {

        super.prepare()

        columMaxHeights.removeAll()

        for _ in 0..<Int(columnCount) {
            columMaxHeights.append(edgeInsets.top)
        }

        attrsArray.removeAll()

        guard let count = collectionView?.numberOfItems(inSection: 0) else {
            return
        }

        for i  in 0..<count {
            let indexPath = NSIndexPath(item: i, section: 0)as IndexPath?
            guard let attr = self.layoutAttributesForItem(at: indexPath! ) else{
                return
            }
            attrsArray.append(attr)
        }
    }
    
    //决定cell排布
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            return attrsArray
    }
    
    //返回indexPath位置的cell对应的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      
        //创建布局属性
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        guard let collectionW = collectionView?.frame.size.width else {
            return nil
        }

        let temp = (columnCount - 1) * columnMargin
        
        let w = (collectionW - edgeInsets.left - edgeInsets.right - temp ) / columnCount
        
        guard let h: CGFloat = delegate?.flowLayoutHeightForItemAtIndex(self, indexPath.item, w) else {
            return nil
        }
        
        var minHeight: CGFloat = columMaxHeights[0]//默认第一列最短
        var destColum = 0   //最短的那一列
        
        for i in 0..<Int(columnCount) {
            let columMaxHeight: CGFloat = columMaxHeights[i]
            if minHeight > columMaxHeight {
                minHeight = columMaxHeight
                destColum = i ;
            }
        }
        
        let x = edgeInsets.left + CGFloat(destColum) * (w + columnMargin)
        var y = minHeight
        //第一列处理
        if y != edgeInsets.top {
            y += rowMargin
        }
        attr.frame = CGRect(x: x, y: y, width: w, height: h)
         //更新最短那列的高度
        columMaxHeights[destColum] = attr.frame.maxY
        return attr
    }
    
    override var collectionViewContentSize: CGSize{
        
        var destMaxY : CGFloat = columMaxHeights[0]
        for i in 0..<Int(columnCount) {
            let columMaxY = columMaxHeights[i]
            if destMaxY < columMaxY {
                destMaxY = columMaxY
            }
        }
        return CGSize(width: 0, height: destMaxY + edgeInsets.bottom)
    }
    
}
