//
//  城市管理
//
//  CityManagerViewController.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CustomBaseViewController.h"

@class CityManagerViewController;
@class WeatherForecastModel;

@protocol CityManagerViewControllerDelegate <NSObject>

- (void)cityManagerViewController:(CityManagerViewController *)cmvController reSelectedCityModel:(WeatherForecastModel *)wfModel selectedIndex:(NSInteger)index;

@end

@interface CityManagerViewController : CustomBaseViewController

@property (nonatomic, weak) id<CityManagerViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * mutableCityArray;

@end
