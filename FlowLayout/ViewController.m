//
//  ViewController.m
//  FlowLayout
//
//  Created by MaBiao on 2018/3/29.
//  Copyright © 2018年 MaBiao. All rights reserved.
//

#import "ViewController.h"
#import "MBFlowLayout.h"
@interface ViewController ()<UICollectionViewDataSource,MBFlowLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 切换布局
    MBFlowLayout *layout = [[MBFlowLayout alloc]init];
    layout.delegate = self;
    
   UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    
    NSInteger tag = 10;
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.tag = tag;
        [cell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    [label sizeToFit];
    
    return cell;
}

#pragma mark - MBFlowLayoutDelegate
- (CGFloat)flowLayout:(MBFlowLayout *)flowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    //真实的高度
    CGFloat realH = 50 + arc4random_uniform(100);
    CGFloat realW = 50 + arc4random_uniform(100);
    
    //按宽高比缩小
    return itemWidth * realH / realW;
}
@end
