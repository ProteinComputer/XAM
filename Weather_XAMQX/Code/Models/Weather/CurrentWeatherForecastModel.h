//
//  CurrentWeatherForecastModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/17.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "GenericModel.h"

@interface CurrentWeatherForecastModel : GenericModel

@property (nonatomic, copy) NSString * city_code;

@property (nonatomic, copy) NSString * weather_day;

@property (nonatomic, copy) NSString * weather_publish_date;

@property (nonatomic, assign) NSInteger one_code;

@property (nonatomic, assign) NSInteger two_code;

@property (nonatomic, copy) NSString * one_code_cn;

@property (nonatomic, copy) NSString * two_code_cn;

@property (nonatomic, assign) NSInteger highest;

@property (nonatomic, assign) NSInteger lowest;

@property (nonatomic, copy) NSString * week;

@end
