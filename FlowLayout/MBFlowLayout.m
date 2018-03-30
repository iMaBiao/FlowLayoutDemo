//
//  MBFlowLayout.m
//  FlowLayout
//
//  Created by MaBiao on 2018/3/29.
//  Copyright © 2018年 MaBiao. All rights reserved.
//

#import "MBFlowLayout.h"
//列间距
static const CGFloat defaultColMargin = 10;
//行间距
static const CGFloat defaultRowMargin = 10;
//默认列数
static const CGFloat defaultColCount = 3;
//边缘间距
static const UIEdgeInsets defaultEdgeInsets = {10,10,10,10};


@interface MBFlowLayout()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放每列最大的Y值 */
@property (nonatomic, strong) NSMutableArray *columMaxHeights;

@end

@implementation MBFlowLayout
- (NSMutableArray *)columMaxHeights
{
    if (!_columMaxHeights) {
        _columMaxHeights = [NSMutableArray array];
    }
    return _columMaxHeights;
}
- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //重置每一列的最大Y值
    [self.columMaxHeights removeAllObjects];
    for (NSInteger i = 0; i < defaultColCount; i++) {
        [self.columMaxHeights addObject:@(defaultEdgeInsets.top)];
    }
    
    //清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
 
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attr];
    }
}
//决定cell排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}
//返回indexPath位置的cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建布局属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    CGFloat collectionW = self.collectionView.frame.size.width;
    
    CGFloat w = (collectionW - defaultEdgeInsets.left - defaultEdgeInsets.right - (defaultColCount - 1)* defaultColMargin) /  defaultColCount;
    CGFloat h = 50 + arc4random_uniform(100);
    
    //找出最大Y值最小的那一列
    CGFloat minHeight = [self.columMaxHeights[0] doubleValue];//默认第一列最短
    NSInteger destColum = 0;//最短的那一列
    for (int i = 1; i < defaultColCount; i++) {
        CGFloat columMaxHeight = [self.columMaxHeights[i] doubleValue];
        if (minHeight > columMaxHeight) {
            minHeight = columMaxHeight;
            destColum = i;
        }
    }
    
    CGFloat x = defaultEdgeInsets.left + destColum * (w + defaultColMargin);
    
    CGFloat y = minHeight;
    
    if (y != defaultEdgeInsets.top) {
        y += defaultRowMargin;
    }
    
    attr.frame  = CGRectMake(x, y, w, h);
    
    self.columMaxHeights[destColum] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}

- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columMaxHeights[0] doubleValue];
    for (int i = 1; i < defaultColCount; i++) {
        // 取出第i列的最大Y值
        CGFloat columMaxY = [self.columMaxHeights[i] doubleValue];
        if (destMaxY < columMaxY) {
            destMaxY = columMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + defaultEdgeInsets.bottom);
}

@end
