//
//  热门城市视图
//
//  HotCityCollectionView.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotCityCollectionView, HotCityModel;

@protocol HotCityCollectionViewDelegate <NSObject>

- (BOOL)hotCityView:(HotCityCollectionView *)hotCityView hotCityModel:(HotCityModel *)hotCityModel;

@end

@interface HotCityCollectionView : UIView

@property (nonatomic, weak) id<HotCityCollectionViewDelegate> delegate;

@property (nonatomic, strong) NSArray * hotCityArray;

@property (nonatomic, strong) UICollectionView * collectionView;

@end
