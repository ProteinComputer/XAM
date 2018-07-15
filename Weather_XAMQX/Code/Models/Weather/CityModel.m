//
//  城市模型
//
//  CityModel.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

+ (NSString *)getPrimaryKey {
    
    return @"oid";
}

+ (NSString *)getTableName {
    
    return @"g_region";
}

+ (int)getTableVersion {
    
    return 20140521;
}

@end
