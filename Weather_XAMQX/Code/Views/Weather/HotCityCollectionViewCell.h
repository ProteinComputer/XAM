//
//  HotCityCollectionViewCell.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotCityModel;

@interface HotCityCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel * cityNameLabel;

- (void)loadDataAndFrame:(HotCityModel *)hotCityModel addState:(BOOL)isExist;

@end
