//
//  LocationModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/10.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (copy,nonatomic) NSString * location_address;
@property (copy,nonatomic) NSString * location_province;
@property (copy,nonatomic) NSString * location_city;
@property (copy,nonatomic) NSString * location_district;
@property (copy,nonatomic) NSString * location_streetName;
@property (copy,nonatomic) NSString * location_streetNumber;

@property (copy,nonatomic) NSString * location_Lat;
@property (copy,nonatomic) NSString * location_Lng;

@end
