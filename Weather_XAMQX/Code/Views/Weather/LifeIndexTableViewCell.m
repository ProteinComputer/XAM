//
//  生活指数
//
//  LifeIndexTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/7.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "LifeIndexTableViewCell.h"

#import "ZDCollectionViewCell.h"

@interface LifeIndexTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView * divideView;

@end

@implementation LifeIndexTableViewCell

#pragma mark - Life cycle.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    if (self) {
        
        [self initUI];
    }
    return self;
}

#pragma mark - Handlers.

- (void)initUI {
    
    [self addSubview:self.divideView];
    
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.indexArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * Identifier = @"ZDCollectionViewCell";
    
    ZDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[ZDCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH -20) / 2, 70)];
    }
    
    NSDictionary * tempDic = self.indexArray[indexPath.row];
    
    [cell.headImageView downloadImage:tempDic[@"url"] placeholder:@"warnicon_0.png"];
    
    cell.titleLabel.text = tempDic[@"type"];
    
    cell.contentLabel.text = tempDic[@"suggest"];
    
    return cell;
}

#pragma mark - Getters and setters.

- (NSArray *)indexArray {
    
    if (!_indexArray) {
        
        _indexArray = [NSArray array];
    }
    return _indexArray;
}

- (UIView *)divideView {
    
    if (!_divideView) {
        
        _divideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _divideView.backgroundColor = [UIColor whiteColor];
    }
    return _divideView;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * collectionViewFlowLayout = [UICollectionViewFlowLayout new];
        collectionViewFlowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 20) / 2, 70);
        collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        collectionViewFlowLayout.minimumInteritemSpacing = 5;
        collectionViewFlowLayout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.height - 10) collectionViewLayout:collectionViewFlowLayout];
        
        [_collectionView registerClass:[ZDCollectionViewCell class] forCellWithReuseIdentifier:@"ZDCollectionViewCell"];
        
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
