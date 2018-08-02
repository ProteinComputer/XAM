//
//  定位城市反Geo解析类
//
//  LocationCityHandle.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/10.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationCityHandle : NSObject

+ (CityModel *)startSearchByLocation:(LocationModel *)locationModel;

@end
