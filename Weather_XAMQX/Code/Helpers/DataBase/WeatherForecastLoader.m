//
//  WeatherForecastLoader.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/15.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//
//
//http://218.202.74.146:10132/product_weather/cityweather/forecast?cityid=10046&token=asdklasndglasdg&sk=false&time=true&warn=true&status=true&forecast=true&zdsk=true&cityinfo=true&lifeindex=true


#import "WeatherForecastLoader.h"

#import "WeatherForecastModel.h"

@implementation WeatherForecastLoader

+ (instancetype)sharedWeatherForecastLoader {
    
    static WeatherForecastLoader * sharedWFLoader = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedWFLoader = [WeatherForecastLoader new];
    });
    
    return sharedWFLoader;
}

/**
 根据天气预报模型加载预报数据

 @param wfModel 天气预报模型
 */
+ (void)weatherForcastLoader:(WeatherForecastModel *)wfModel {
    
    NSMutableDictionary * mutableParamterDic = [NSMutableDictionary dictionary];
    
    [mutableParamterDic setObject:@"true" forKey:@"time"];
    [mutableParamterDic setObject:@"true" forKey:@"warn"];
    [mutableParamterDic setObject:@"true" forKey:@"status"];
    [mutableParamterDic setObject:@"true" forKey:@"forecast"];
    [mutableParamterDic setObject:@"true" forKey:@"zdsk"];
    [mutableParamterDic setObject:@"true" forKey:@"cityinfo"];
    [mutableParamterDic setObject:@"true" forKey:@"lifeindex"];
    
    if (wfModel && wfModel.target_id) {
        
        [mutableParamterDic setObject:wfModel.target_id forKey:@"cityid"];
        [mutableParamterDic setObject:SHARED_APPDELEGATE.userModel.userToken forKey:@"token"];
        
        [HTTPTool postWitPath:API_CITY_FORECAST params:mutableParamterDic success:^(id json) {
            
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            
            NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            wfModel.forcastContent = jsonString;
            
            [SHARED_APPDELEGATE.getDBHander updateToDB:wfModel where:nil];
        } failure:^(NSError *error) {
            NSLog(@"Error is %@", error);
        }];
    } else {
        NSLog(@"Error is no target_id!");
    }
}

@end
