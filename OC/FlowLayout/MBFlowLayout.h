//
//  MBFlowLayout.h
//  FlowLayout
//
//  Created by MaBiao on 2018/3/29.
//  Copyright © 2018年 MaBiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBFlowLayout;

@protocol MBFlowLayoutDelegate<NSObject>
@required
//外部设置布局的高度
- (CGFloat)flowLayout:(MBFlowLayout *)flowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional

- (CGFloat)numOfRowMarginInFlowLayout:(MBFlowLayout *)flowLayout;

- (CGFloat)columnCountInFlowLayout:(MBFlowLayout *)flowLayout;

- (CGFloat)columnMarginInFlowLayout:(MBFlowLayout *)flowLayout;

- (UIEdgeInsets)edgeInsetsInFlowLayout:(MBFlowLayout *)flowLayout;

@end

@interface MBFlowLayout : UICollectionViewLayout

@property(nonatomic, weak)id<MBFlowLayoutDelegate> delegate;

@end
