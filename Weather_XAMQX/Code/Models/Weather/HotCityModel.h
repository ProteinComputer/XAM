//
//  HotCityModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/10.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GenericModel.h"

@interface HotCityModel : GenericModel

@property (nonatomic, assign) NSInteger city_order;

@property (nonatomic, assign) NSInteger city_oid;

@property (nonatomic, copy) NSString * city_name;

@property (nonatomic, assign) BOOL addState;

@end
