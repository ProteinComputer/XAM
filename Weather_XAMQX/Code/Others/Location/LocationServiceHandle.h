//
//  LocationServiceHandle.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocationServiceHandle, CityModel;

@protocol LocationServiceDelegate <NSObject>

- (void)didStartLocationService:(LocationServiceHandle *)locationServiceHandle;

- (void)didFailLocationService:(LocationServiceHandle *)locationServiceHandle;

- (void)didReverseGeoLocationService:(LocationServiceHandle *)locationServiceHandle coord:(CLLocationCoordinate2D)coord;

- (void)didFinishLocationService:(LocationServiceHandle *)locationServiceHandle reInfo:(CityModel *)cityModel reAddress:(NSString *)addressString;

@end

@interface LocationServiceHandle : NSObject

@property (nonatomic, weak) id<LocationServiceDelegate> delegate;

- (void)initLocationService;

- (void)startLocationService;

@end
