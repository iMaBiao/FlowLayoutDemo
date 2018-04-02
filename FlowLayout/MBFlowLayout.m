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

- (CGFloat)rowMargin;
- (CGFloat)columnCount;
- (CGFloat)columnMargin;
- (UIEdgeInsets)edgeInsets;
@end

@implementation MBFlowLayout

#pragma mark - 数据处理
- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(numOfRowMarginInFlowLayout:)]) {
        return [self.delegate numOfRowMarginInFlowLayout:self];
    }else{
        return defaultRowMargin;
    }
}
- (CGFloat)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInFlowLayout:)]) {
        return [self.delegate columnCountInFlowLayout:self];
    }else{
        return defaultColCount;
    }
}
- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInFlowLayout:)]) {
        return [self.delegate columnMarginInFlowLayout:self];
    }else{
        return defaultColMargin;
    }
}
- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInFlowLayout:)]) {
        return [self.delegate edgeInsetsInFlowLayout:self];
    }else{
        return defaultEdgeInsets;
    }
}

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

//初始化，每次布局都调用
- (void)prepareLayout
{
    [super prepareLayout];
    
    //重置每一列的最大Y值
    [self.columMaxHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columMaxHeights addObject:@(self.edgeInsets.top)];
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
    
    CGFloat w = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1)* self.columnMargin) /  self.columnCount;
    
    //利用代理，外部设置高度
    CGFloat h = [self.delegate flowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    //找出最大Y值最小的那一列
    CGFloat minHeight = [self.columMaxHeights[0] doubleValue];//默认第一列最短
    NSInteger destColum = 0;//最短的那一列
    for (int i = 1; i < self.columnCount; i++) {
        CGFloat columMaxHeight = [self.columMaxHeights[i] doubleValue];
        if (minHeight > columMaxHeight) {
            minHeight = columMaxHeight;
            destColum = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColum * (w + self.columnMargin);
    CGFloat y = minHeight;
    //第一列处理
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    
    attr.frame  = CGRectMake(x, y, w, h);
    
    //更新最短那列的高度
    self.columMaxHeights[destColum] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}

- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columMaxHeights[0] doubleValue];
    for (int i = 1; i < self.columnCount; i++) {
        // 取出第i列的最大Y值
        CGFloat columMaxY = [self.columMaxHeights[i] doubleValue];
        if (destMaxY < columMaxY) {
            destMaxY = columMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + self.edgeInsets.bottom);
}

@end
