//
//  HotCityModel.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/10.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "HotCityModel.h"

@implementation HotCityModel

+(NSString *)getPrimaryKey
{
    return @"city_oid";
}
+(NSString *)getTableName
{
    return @"hotCity";
}
+(int)getTableVersion
{
    return 20160819;
}

@end
