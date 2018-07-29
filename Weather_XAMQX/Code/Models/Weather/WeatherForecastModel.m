//
//  城市天气预报模型
//
//  WeatherForecastModel.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "WeatherForecastModel.h"

@implementation WeatherForecastModel

- (id)initWithCityModel:(CityModel *)aCityModel {
    
    if (self = [super init]) {
        
        if (aCityModel != nil) {
            
            self.oid = aCityModel.target_id;
            
            self.isLocation = 0;
            
            self.name = aCityModel.name;
            
            self.lat = aCityModel.lat;
            
            self.lng = aCityModel.lng;
            
            self.english_name = aCityModel.english_name;
            
            self.target_id = aCityModel.target_id;
            
            self.short_name = aCityModel.short_name;
            
            self.full_name = aCityModel.full_name;
            
            self.post_code = aCityModel.post_code;
            
            self.addDate = [NSDate date];
        }
    }
    
    return self;
}

+ (NSString *)getPrimaryKey {
    
    return @"oid";
}

+ (NSString *)getTableName {
    
    return @"forcast";
}

+ (int)getTableVersion {
    
    return 20150423;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"forcastContent = %@", self.forcastContent];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
