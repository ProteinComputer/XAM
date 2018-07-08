//
//  天气首页
//
//  WeatherViewController.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/4.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController

@property (nonatomic, strong) UICollectionView *    collectionView;

@property (nonatomic, strong) NSMutableArray *      userCityMutableArray;

@property (nonatomic, strong) UILabel *             baseTitleLabel;

@end
