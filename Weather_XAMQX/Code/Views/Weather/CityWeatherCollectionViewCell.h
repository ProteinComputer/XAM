//
//  WeatheCollectionViewCell.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeatherForecastModel.h"

@class CityWeatherCollectionViewCell;

@protocol CityWeatherCollectionViewCellDelegate <NSObject>

- (void)cityWeatherUpdate:(CityWeatherCollectionViewCell *)cityWeatherCollectionViewCell withForecastCityModel:(WeatherForecastModel *)weatherForecastModel;

- (void)cityWeatherUpdate:(CityWeatherCollectionViewCell *)cityWeatherCollectionViewCell withWarning:(NSDictionary *)warning;

- (void)cityWeatherUpdate:(CityWeatherCollectionViewCell *)cityWeatherCollectionViewCell withScrollView:(UIScrollView *)scrollView;

@end

@interface CityWeatherCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <CityWeatherCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) WeatherForecastModel * weatherForecastModel;

- (void)setNoData:(BOOL)showNodata;

- (void)loadNewData;

- (void)readDBData;



@end
