//
//  LocationServiceHandle.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "LocationServiceHandle.h"

#import "LocationModel.h"
#import "LocationCityHandle.h"
#import "CityModel.h"

@interface LocationServiceHandle () <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKLocationService * bmkLocationService;

@property (nonatomic, strong) BMKGeoCodeSearch * bmkGeoCodeSearch;

@property (nonatomic, strong) BMKReverseGeoCodeSearchOption * reversGeoCodeSearchOption;

@end

@implementation LocationServiceHandle

#pragma mark - Handlers.

- (void)initLocationService {
    
    [self startLocationService];
    
    self.bmkGeoCodeSearch.delegate = self;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didStartLocationService:)]) {
        
        [self.delegate didStartLocationService:self];
    }
}

- (void)startLocationService {
    [self.bmkLocationService startUserLocationService];
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {}//转向

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    self.reversGeoCodeSearchOption.location = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BOOL flag = [self.bmkGeoCodeSearch reverseGeoCode:self.reversGeoCodeSearchOption];
    
    if (flag) {
        
        NSLog(@"反Geo检索发送成功");
        if (self.delegate && [self.delegate respondsToSelector:@selector(didReverseGeoLocationService:coord:)]) {
            
            [self.delegate didReverseGeoLocationService:self coord:userLocation.location.coordinate];
        }
    } else {
        NSLog(@"反Geo检索发送失败");
    }
    
    [self.bmkLocationService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFailToLocateUserWithError:)]) {
        
        [self.delegate didFailLocationService:self];
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (!error) {
        
        LocationModel * locationModel = [LocationModel new];
        locationModel.location_address = result.address;
        locationModel.location_province = result.addressDetail.province;
        locationModel.location_city = result.addressDetail.city;
        locationModel.location_district = result.addressDetail.district;
        locationModel.location_streetName = result.addressDetail.streetName;
        locationModel.location_streetNumber = result.addressDetail.streetNumber;
        
        CityModel * cityModel = [LocationCityHandle startSearchByLocation:locationModel];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishLocationService:reInfo:reAddress:)]) {
            
            [self.delegate didFinishLocationService:self reInfo:cityModel reAddress:result.address];
        }
    } else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didFailLocationService:)]) {
            
            [self.delegate didFailLocationService:self];
        }
    }
}

#pragma mark - Getters and setters.

- (BMKLocationService *)bmkLocationService {
    
    if (!_bmkLocationService) {
        
        _bmkLocationService = [BMKLocationService new];
        _bmkLocationService.delegate = self;
    }
    return _bmkLocationService;
}

- (BMKGeoCodeSearch *)bmkGeoCodeSearch {
    
    if (!_bmkGeoCodeSearch) {
        
        _bmkGeoCodeSearch = [BMKGeoCodeSearch new];
    }
    return _bmkGeoCodeSearch;
}

- (BMKReverseGeoCodeSearchOption *)reversGeoCodeSearchOption {
    
    if (!_reversGeoCodeSearchOption) {
        
        _reversGeoCodeSearchOption = [BMKReverseGeoCodeSearchOption new];
    }
    return _reversGeoCodeSearchOption;
}

@end
