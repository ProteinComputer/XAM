//
//  AppDelegate.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/3.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@class CityModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UserModel * userModel;

@property (nonatomic,strong) LKDBHelper * dbHelper;

@property (nonatomic, strong) CityModel * locationCityModel;

- (LKDBHelper *)getDBHander;

@end

