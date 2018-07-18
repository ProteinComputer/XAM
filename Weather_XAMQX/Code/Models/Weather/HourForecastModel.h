//
//  HourForecastModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/18.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//
//  -> SingleForecastHourModel.h
//

#import "GenericModel.h"

@interface HourForecastModel : GenericModel

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString * createTime;

@property (nonatomic, copy) NSString * updateTime;

@property (nonatomic, copy) NSString * city_code;

@property (nonatomic, assign) CGFloat temp;

@property (nonatomic, assign) NSInteger rain;

@property (nonatomic, assign) NSInteger humidity;

@property (nonatomic, copy) NSString * press;

@property (nonatomic, assign) CGFloat wind_velocity;

@property (nonatomic, assign) CGFloat wind_direction;

@property (nonatomic, copy) NSString * obstime;

@property (nonatomic, copy) NSString * publish_time;

@end
