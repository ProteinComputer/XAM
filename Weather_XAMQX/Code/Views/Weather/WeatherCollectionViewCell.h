//
//  WeatheCollectionViewCell.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeatherForecastModel.h"

@class WeatherCollectionViewCell;

@protocol WeatherCollectionViewCellDelegate <NSObject>

- (void)cityWeatherUpdate:(WeatherCollectionViewCell *)cityWeatherCollectionViewCell withForecastCityModel:(WeatherForecastModel *)weatherForecastModel;

- (void)cityWeatherUpdate:(WeatherCollectionViewCell *)cityWeatherCollectionViewCell withWarning:(NSDictionary *)warning;

- (void)cityWeatherUpdate:(WeatherCollectionViewCell *)cityWeatherCollectionViewCell withScrollView:(UIScrollView *)scrollView;

@end

@interface WeatherCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <WeatherCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) WeatherForecastModel * weatherForecastModel;

- (void)setNoData:(BOOL)showNodata;

- (void)loadNewData;

- (void)readDBData;



@end
