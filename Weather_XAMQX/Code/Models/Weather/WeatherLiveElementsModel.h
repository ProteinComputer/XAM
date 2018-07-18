//
//  WeatherLiveElementsModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/17.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "GenericModel.h"

@interface WeatherLiveElementsModel : GenericModel

@property (nonatomic, copy) NSString * air_aqi;

@property (nonatomic, assign) NSInteger air_aqi_value;

@property (nonatomic, copy) NSString * sunset_out;

@property (nonatomic, copy) NSString * sunset_in;

@property (nonatomic, copy) NSString * code;

@property (nonatomic, assign) CGFloat temperature;

@property (nonatomic, assign) CGFloat rain;

@property (nonatomic, assign) NSInteger humidity;

@property (nonatomic, assign) CGFloat press;

@property (nonatomic, assign) CGFloat wind_speed;

@property (nonatomic, copy) NSString * wind_speed_describe;

@property (nonatomic, assign) NSInteger wind_direction;

@property (nonatomic, copy) NSString * wind_direction_describe;

@property (nonatomic, copy) NSString * obstime;

@property (nonatomic, copy) NSString * systime;

@end
