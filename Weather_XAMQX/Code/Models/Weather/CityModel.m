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

+ (NSString *)getTabelName {
    
    return @"g_region_new";
}

+ (int)getTableVersion {
    
    return 20170508;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
