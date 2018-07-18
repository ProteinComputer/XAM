//
//  CityInfoModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/18.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//
//  -> CityinfoModel.h
//

#import "GenericModel.h"

@interface CityInfoModel : GenericModel

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * city_code;

@property (nonatomic, copy) NSString * city_tabtime_code;

@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, assign) CGFloat longitude;

@end
