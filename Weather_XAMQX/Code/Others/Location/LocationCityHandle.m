//
//  定位城市反Geo解析类
//
//  LocationCityHandle.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/10.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "LocationCityHandle.h"

#import "CityModel.h"
#import "LocationModel.h"

@implementation LocationCityHandle

+ (instancetype)sharedCityLocationInfo {
    
    static LocationCityHandle * lcHandle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lcHandle = [LocationCityHandle new];
    });
    return lcHandle;
}

+ (CityModel *)startSearchByLocation:(LocationModel *)locationModel {
    
    CityModel * queriedCityModel = [CityModel new];
    
//    LKDBHelper * dbHelper = [LKDBHelper getUsingLKDBHelper];
     LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    NSArray * tempArray = [dbHelper search:[CityModel class] where:@"level = 1" orderBy:nil offset:0 count:40];
    
    //省
    for (CityModel * citymodel in tempArray) {
        
        if ([locationModel.location_province rangeOfString:citymodel.name].length > 0) {
            
            queriedCityModel = citymodel;
            break;
        }
    }
    
    //市
    NSString * sqlStr = [NSString stringWithFormat:@"pid = %@ and level = 2", queriedCityModel.oid];
    tempArray = [dbHelper search:[CityModel class] where:sqlStr orderBy:nil offset:0 count:300];
    for (CityModel * citymodel in tempArray) {
        
        if ([citymodel.full_name rangeOfString:locationModel.location_city].length > 0) {
            
            if ([locationModel.location_district isEqualToString:citymodel.name]) {
                
                queriedCityModel = citymodel;
                break;
            } else {
                
                if ([citymodel.full_name rangeOfString:locationModel.location_city].length > 0) {
                    queriedCityModel = citymodel;
                }
            }
        }
    }
    
    //区县
    sqlStr = [NSString stringWithFormat:@"pid = %@ and level = 3", queriedCityModel.oid];
    
    tempArray = [dbHelper search:[CityModel class] where:sqlStr orderBy:nil offset:0 count:300];
    
    for (CityModel * cityModel in tempArray) {
        
        if ([cityModel.full_name rangeOfString:locationModel.location_city].length > 0) {
            
            if ([locationModel.location_district isEqualToString:cityModel.name]) {
                
                queriedCityModel = cityModel;
                break;
            } else {
                if ([cityModel.full_name rangeOfString:locationModel.location_city].length > 0) {
                    
                    queriedCityModel = cityModel;
                }
            }
        }
    }
    
    SHARED_APPDELEGATE.locationCityModel = queriedCityModel;
    
    return queriedCityModel;
}

@end
