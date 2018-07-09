//
//  AppDelegate.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/3.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "AppDelegate.h"

#import "CreateCityDB.h"
#import "UserModel.h"
#import "CityModel.h"
#import "WeatherForecastModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Getters and setters.

- (LKDBHelper *)getDBHander {
    
    if (!_dbHelper) {
        self.dbHelper = [LKDBHelper getUsingLKDBHelper];
    }
    return _dbHelper;
}

- (WeatherForecastModel *)addLocationCity {
    
    WeatherForecastModel * weatherForecastModel = [[WeatherForecastModel alloc] init];
    
    if (self.locationCityModel && self.locationCityModel.target_id.length > 0) {
        
        weatherForecastModel.oid = self.locationCityModel.oid;
        weatherForecastModel.target_id = self.locationCityModel.target_id;
        weatherForecastModel.name = self.locationCityModel.name;
        weatherForecastModel.short_name = self.locationCityModel.short_name;
        weatherForecastModel.full_name = self.locationCityModel.full_name;
        weatherForecastModel.english_name = self.locationCityModel.english_name;
        weatherForecastModel.post_code = self.locationCityModel.post_code;
        weatherForecastModel.lat = self.locationCityModel.lat;
        weatherForecastModel.lng = self.locationCityModel.lng;
        
        weatherForecastModel.forcastContent = @"";
        weatherForecastModel.updateTime = @"";
        weatherForecastModel.isLocation = @"1";
    }
    
    NSArray * tempArray = [self.getDBHander search:[WeatherForecastModel class] where:@" isLocation = \'1\'" orderBy:nil offset:0 count:1];
    
    if (tempArray.count > 0) {
        
        WeatherForecastModel * tempWFModel = [tempArray firstObject];
        
        if (![tempWFModel.oid isEqualToString:weatherForecastModel.oid]) {
            
            [self.getDBHander deleteToDB:[tempArray firstObject]];
            [self.getDBHander insertToDB:weatherForecastModel];
            
            [self loadNewData:weatherForecastModel];
        }
    } else {
        
        [self.getDBHander insertToDB:weatherForecastModel];
        [self loadNewData:weatherForecastModel];
    }
    
    return weatherForecastModel;
}


- (void)loadNewData:(WeatherForecastModel *)wfModel {
    
    NSMutableDictionary * prarmDic = [[NSMutableDictionary alloc] init];
    [prarmDic setObject:@"true" forKey:@"time"];
    [prarmDic setObject:@"true" forKey:@"warn"];
    [prarmDic setObject:@"true" forKey:@"status"];
    [prarmDic setObject:@"true" forKey:@"forecast"];
    [prarmDic setObject:@"true" forKey:@"zdsk"];
    [prarmDic setObject:@"true" forKey:@"cityinfo"];
    [prarmDic setObject:@"true" forKey:@"lifeindex"];
    
    if (wfModel != nil && wfModel.target_id != nil) {
        
        [prarmDic setObject:wfModel.target_id forKey:@"cityid"];
    } else {
        NSLog(@"AppDelegate - loadNewData: logs data lost with %@", wfModel.target_id);
    }
    
    [prarmDic setObject:self.userModel.userToken forKey:@"token"];
    
    [HTTPTool postWitPath:API_CITY_FORECAST params:prarmDic success:^(id json) {
       
        //存储数据
        NSString * aStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        
        wfModel.forcastContent = aStr;
        NSLog(@"AppDelegate - loadNewData: aStr: %@", aStr);
        
        [self.getDBHander updateToDB:wfModel where:nil];
        
    } failure:^(NSError * error) {
        NSLog(@"AppDelegate - loadNewData: HTTPTool postWitPath: error is %@", error);
    }];
}

#pragma mark - Life cycle.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[NSThread sleepForTimeInterval:1.0];
    
    CreateCityDB * createCitiesDB = [CreateCityDB new];
    [createCitiesDB initCitiesDatabase];
    
    if (!self.userModel) {
        self.userModel = [UserModel new];
        self.userModel.userToken = @"NOTOKEN";
    }
    
    TTT
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
