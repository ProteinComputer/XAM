//
//  用户已添加城市列表和天气预报
//
//  UserCityWeatherForecastTableViewCell.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/17.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherLiveElementsModel, CurrentWeatherForecastModel;

@interface UserCityWeatherForecastTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * moveImageView;

@property (nonatomic, strong) UIView * weatherImageBackView;

@property (nonatomic, strong) UIImageView * weatherImageView;

@property (nonatomic, strong) UILabel * cityNameLabel;

@property (nonatomic, strong) UILabel * currentForecastLabel;

@property (nonatomic, strong) UILabel * currentTemperatureLabel;

@property (nonatomic, strong) UIImageView * locationImageView;

@property (nonatomic, strong) WeatherLiveElementsModel * wleModel;

@property (nonatomic, strong) CurrentWeatherForecastModel * cwfModel;

- (void)loadCityName:(NSString *)cityName weatherLiveElementsModel:(WeatherLiveElementsModel *)wleModel currentWeatherForecastModel:(CurrentWeatherForecastModel *)cwfModel;

@end
