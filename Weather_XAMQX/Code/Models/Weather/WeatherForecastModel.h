//
//  城市天气预报模型
//
//  WeatherForecastModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityModel.h"

@interface WeatherForecastModel : NSObject

@property (nonatomic, copy) NSString * oid;

@property (nonatomic, copy) NSString * target_id;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * short_name;

@property (nonatomic, copy) NSString * full_name;

@property (nonatomic, copy) NSString * english_name;

@property (nonatomic, copy) NSString * post_code;

@property (nonatomic, copy) NSString * lat;

@property (nonatomic, copy) NSString * lng;

@property (nonatomic, copy) NSString * updateTime;

@property (nonatomic, copy) NSString * forcastContent;

@property (nonatomic, copy) NSString * isLocation;

@property (nonatomic, copy) NSString * bgImagePath;

@property (nonatomic, copy) NSString * cityLiveInfo;

@property (nonatomic, copy) NSString * liveUpdateTime;

@property (nonatomic, strong) NSData * addDate;

- (id)initWithCityModel:(CityModel *)aCityModel;

@end
