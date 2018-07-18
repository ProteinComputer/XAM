//
//  热门城市视图
//
//  HotCityCollectionView.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "HotCityCollectionView.h"

#import "HotCityCollectionViewCell.h"
#import "HotCityModel.h"

@interface HotCityCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>


@end

@implementation HotCityCollectionView

#pragma mark - Life cycle.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
    }
    return self;
}

#pragma mark - Handlers.

- (void)initUI {
    
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource.

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotCityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * indentifier = @"HotCityCollectionViewCell";
    HotCityCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[HotCityCollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 70) / 2, 30)];
    }
    
    HotCityModel * hotCiytModel = self.hotCityArray[indexPath.row];
    [cell loadDataAndFrame:hotCiytModel addState:hotCiytModel.addState];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HotCityModel * hotCityModel = self.hotCityArray[indexPath.row];
    
    if (!hotCityModel.addState) {
        
        HotCityCollectionViewCell * cell = (HotCityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(hotCityView:hotCityModel:)]) {
            
            BOOL addState = [self.delegate hotCityView:self hotCityModel:hotCityModel];
            
            if (addState) {
                hotCityModel.addState = YES;
                [cell loadDataAndFrame:hotCityModel addState:addState];
            }
        }
    }
}

#pragma mark - Getters and setters.

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * collectionViewFlowLayout = [UICollectionViewFlowLayout new];
        collectionViewFlowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 70) / 4, 30);
        collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        collectionViewFlowLayout.minimumInteritemSpacing = 5;
        collectionViewFlowLayout.minimumLineSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:collectionViewFlowLayout];
        [_collectionView registerClass:[HotCityCollectionViewCell class] forCellWithReuseIdentifier:@"HotCityCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSArray *)hotCityArray {
    
    if (!_hotCityArray) {
        
        _hotCityArray = [NSArray array];
    }
    return _hotCityArray;
}

@end
