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
#import "LocationModel.h"
#import "HotCityModel.h"
#import "LocationCityHandle.h"
#import "WeatherForecastLoader.h"

@interface AppDelegate () <BMKGeneralDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapManager * baiduMapMange;

@property (nonatomic, strong) BMKLocationService * baiduLocationService;

@property (nonatomic, strong) BMKGeoCodeSearch * baiduGeoCodeSearch;

@property (nonatomic, strong) BMKReverseGeoCodeSearchOption * reverseGeoCodeSearchOption;

@end

@implementation AppDelegate

#pragma mark - Life cycle.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //[NSThread sleepForTimeInterval:1.0];
    
    [self copyFileDatabase];
    
    self.CURRNONETVC = 0;
    
    [self registerDevice];
    
    [self loadHotCity];
    
    [self saveNewCity];
    
    if ([self.baiduMapMange start:BAIDU_MAPKIT_KEY generalDelegate:self]) {
        NSLog(@"BaiduMapManger initialized!");
    } else {
        NSLog(@"BaiduMapManager failed to initiate!");
    };
    
    [self.baiduLocationService startUserLocationService];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self clearCache];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - Device processing.

//注册设备并加载数据
- (void)registerDevice {
    
    //http://218.202.74.146:10132/product_weather/deviceinfos/saveDeviceInfos?system=ios&device_code=12345asd6&versions=1000&baidu_id=q3r0fastw&baidu_key=asdlgnasldgn&phone_brand=sanxing
    
    NSMutableDictionary * parameterDic = [[NSMutableDictionary alloc] init];
    [parameterDic setObject:self.userModel.userToken forKey:@"token"];
    [parameterDic setObject:@"iphone" forKey:@"system"];
    [parameterDic setObject:IDFV forKey:@"device_code"];
    [parameterDic setObject:CF_BUNDLE_VERSION forKey:@"versions"];
    [parameterDic setObject:@"Apple" forKey:@"phone_brand"];
    [parameterDic setObject:DEVICE_MODEL forKey:@"phone_model"];
    [parameterDic setObject:@"V1" forKey:@"api_level"];
    [parameterDic setObject:@(SCREEN_WIDTH) forKey:@"screen_width"];
    [parameterDic setObject:@(SCREEN_HEIGHT) forKey:@"screen_height"];
    
    [HTTPTool postWitPath:API_DEVICE_INFOS params:parameterDic success:^(id json) {
        
        NSDictionary * tempDic = (NSDictionary *)json;
        
        self.userModel.userToken = tempDic[@"token"];
        
        if (self.userModel.userToken) {
            
            if ([[NSUserDefaults standardUserDefaults] stringForKey:@"userName"].length > 0 && [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"].length > 0) {
            }
        }
        
        NSArray * array = [self.getDBHander search:[WeatherForecastModel class] where:@"" orderBy:nil offset:0 count:9];
        
        for (WeatherForecastModel * wfModel in array) {
            [WeatherForecastLoader weatherForcastLoader:wfModel];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error is %@", error);
    }];
}

- (void)checkVersion {
    
    //http://218.202.74.146:10132/product_weather/deviceinfos/isNewVersion?token=asdf&mobile=android&version=1022
    
    NSMutableDictionary * parameterDic = [[NSMutableDictionary alloc] init];
    [parameterDic setObject:self.userModel.userToken forKey:@"token"];
    [parameterDic setObject:@"iphone" forKey:@"mobile"];
    [parameterDic setObject:@"100" forKey:@"version"];
    
    [HTTPTool postWitPath:API_DEVICE_VERSION params:parameterDic success:^(id json) {
        NSLog(@"json %@", json);
    } failure:^(NSError *error) {
        NSLog(@"Error is %@", error);
    }];
}

#pragma mark - Data processing.

- (void)saveNewCity {
    
    return;
    LKDBHelper * dbHelper = [self getDBHander];
    
    [LKDBHelper clearTableData:[CityModel class]];
    
    NSString * g_regionFilePath = [[NSBundle mainBundle] pathForResource:@"g_region.txt" ofType:nil];
    NSString * g_region_aFilePath = [[NSBundle mainBundle] pathForResource:@"g_region_a.txt" ofType:nil];
    
    NSString * g_regionStr = [NSString stringWithContentsOfFile:g_regionFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString * g_region_aStr = [NSString stringWithContentsOfFile:g_region_aFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray * cityArray = [g_regionStr componentsSeparatedByString:@"\n"];
    NSArray * cityFullNameArray = [g_region_aStr componentsSeparatedByString:@"\n"];
    
    NSInteger index = 0;
    
    for (NSString * cityCol in cityArray) {
        //110100,北京市,2,北京,Beijing,110000,100000,39.904989,116.405285,10000,,1002,101010100,54511,1,bei jing,B,BJ
        NSArray * cityCols = [cityCol componentsSeparatedByString:@","];
        
        if (cityCols.count == 18) {
            
            CityModel * cityModel = [CityModel new];
            cityModel.oid = cityCols[0];
            cityModel.name = cityCols[1];
            cityModel.level = [cityCols[2] intValue];
            cityModel.short_name = cityCols[3];
            cityModel.english_name = cityCols[4];
            cityModel.pid = cityCols[5];
            cityModel.post_code = cityCols[6];
            cityModel.lat = cityCols[7];
            cityModel.lng = cityCols[8];
            cityModel.target_id = cityCols[9];
            cityModel.target_cid = cityCols[10];
            cityModel.target_pid = cityCols[11];
            cityModel.target_nid = cityCols[12];
            cityModel.target_sid = cityCols[13];
            cityModel.target_real = cityCols[14];
//            cityModel.shortName_pinyin = cityCols[15];
//            cityModel.indexChar = cityCols[16];
//            cityModel.shortName_ShortPinyin = cityCols[17];
            cityModel.full_name = cityFullNameArray[index];
            
            [dbHelper insertToDB:cityModel];
        } else {
            NSLog(@"---- cityClos ---- %@", cityCols[1]);
        }
        
        index ++ ;
    }
}

- (void)loadHotCity {
    
    [HTTPTool getWitPath:API_HOT_CITY params:nil success:^(id json) {
        
        NSDictionary * resultDic = (NSDictionary *)json;
    
        NSArray * hotCityArray = [[HotCityModel class] mj_objectArrayWithKeyValuesArray:resultDic[@"datas"][@"cityHots"]];
        
        if (hotCityArray) {
            
            [LKDBHelper clearTableData:[HotCityModel class]];
        }
        
        for (HotCityModel * hotCity in hotCityArray) {
            [self.dbHelper insertWhenNotExists:hotCity];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Error is %@", error);
    }];
}

//拷贝数据库文件到用户Documents/db文件夹下
- (void)copyFileDatabase {
    
    NSString * applicationPath = [[NSBundle mainBundle] pathForResource:@"clovernew_20170508.db" ofType:nil];
    
    NSString * dbPath = [NSString catchPathWithFileName:DATABASE_FOLDER];
    
    [self createFolder:dbPath];
    
    NSString * bundlePath = nil;
    
    //1008版本升级后数据库加密并更换存储位置
    if ([CF_BUNDLE_VERSION integerValue] >= 1008) {
        bundlePath = [dbPath stringByAppendingPathComponent:DATABASE_NAME];
        NSLog(@"bundlePath %@", bundlePath);
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        [[NSFileManager defaultManager] copyItemAtPath:applicationPath toPath:bundlePath error:nil];
    } else {
        
        //更新数据库
        CityModel * cityModelTemp1 = [CityModel new];
        cityModelTemp1.oid = @"152221";
        cityModelTemp1.name = @"科尔沁右翼前旗";
        cityModelTemp1.short_name = @"科右前旗";
        cityModelTemp1.level = 3;
        cityModelTemp1.full_name = @"内蒙古自治区,兴安盟,科尔沁右翼前旗";
        cityModelTemp1.english_name = @"Keyouqianqi";
        cityModelTemp1.pid = @"152200";
        cityModelTemp1.post_code = @"137400";
        cityModelTemp1.lat = @"46.0795";
        cityModelTemp1.lng = @"121.95269";
        cityModelTemp1.target_id = @"10378";
        cityModelTemp1.target_cid = @"";
        cityModelTemp1.target_pid = @"1029";
        cityModelTemp1.target_nid = @"101081109";
        cityModelTemp1.target_sid = @"50834";
        cityModelTemp1.target_real = @"1";
        cityModelTemp1.target_sid = @"50834";
        
        [self.getDBHander updateToDB:cityModelTemp1 where:@"oid = 152221"];
        
        CityModel * cityModelTemp2 = [CityModel new];
        cityModelTemp2.oid = @"500300";
        cityModelTemp2.short_name = @"两江新区";
        cityModelTemp2.level = 3;
        cityModelTemp2.full_name = @"重庆,重庆市,两江新区";
        cityModelTemp2.english_name = @"Liangjiangxinqu";
        cityModelTemp2.pid = @"500100";
        cityModelTemp2.post_code = @"400000";
        cityModelTemp2.lat = @"29.729153";
        cityModelTemp2.lng = @"106.463344";
        cityModelTemp2.target_id = @"10040";
        cityModelTemp2.target_cid = @"";
        cityModelTemp2.target_pid = @"1023";
        cityModelTemp2.target_real = @"0";
        
        [self.getDBHander updateToDB:cityModelTemp2 where:@"oid = 500300"];
        
        WeatherForecastModel * wfModel = [WeatherForecastModel new];
        wfModel.oid = @"152200";
        [self.getDBHander deleteToDB:wfModel];
    }
}

- (void)clearCache {
    
    NSString * cache = [[NSUserDefaults standardUserDefaults] objectForKey:@"clearCache"];
    
    if ([cache integerValue] == 1) return;
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        NSArray * filePaths = [[NSFileManager defaultManager] subpathsAtPath:CACHE_PATH];
        
        NSLog(@"files %ld", [filePaths count]);
        
        for (NSString * eachPath in filePaths) {
            
            NSError * error = nil;
            
            NSString * path = [CACHE_PATH stringByAppendingPathComponent:eachPath];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearResult) withObject:nil waitUntilDone:YES];
        
    });
}

- (void)clearResult {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"clearCache"];
    NSLog(@"清理成功!");
}

//创建文件夹
- (void)createFolder:(NSString *)folderName {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    BOOL existed = [fileManager fileExistsAtPath:folderName isDirectory:&isDir];
    
    if (!existed) {
        
        [fileManager createDirectoryAtPath:folderName withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    self.locationModel.location_Lat = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.latitude];
    self.locationModel.location_Lng = [NSString stringWithFormat:@"%f", userLocation.location.coordinate.longitude];
    
    self.reverseGeoCodeSearchOption.location = {userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BOOL flag = [self.baiduGeoCodeSearch reverseGeoCode:self.reverseGeoCodeSearchOption];
    
    if (flag) {
        NSLog(@"反Geo检索发送成功!");
    } else {
        NSLog(@"反Geo检索发送失败!");
    }
    [self.baiduLocationService stopUserLocationService];
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"FailToLocationUser! Error is %@", error);
}

#pragma mark - BMKGeoCodeSearchDelegate

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == 0) {
        
        self.locationModel.location_address = result.address;
        self.locationModel.location_province = result.addressDetail.province;
        self.locationModel.location_city = result.addressDetail.city;
        self.locationModel.location_district = result.addressDetail.district;
        self.locationModel.location_streetName = result.addressDetail.streetName;
        self.locationModel.location_streetNumber = result.addressDetail.streetNumber;
        
        NSLog(@"ReverseGeoCodeResult %@ %@ %@", result.addressDetail.province, result.addressDetail.city, result.addressDetail.district);
        
        [LocationCityHandle startSearchByLocation:self.locationModel];
        
        [self addLocationCity];
    } else {}
}

#pragma mark - Getters and setters.

- (BMKMapManager *)baiduMapMange {
    
    if (!_baiduMapMange) {
        
        _baiduMapMange = [BMKMapManager new];
        
//        BOOL result =  [_baiduMapMange start:BAIDU_MAPKIT_KEY generalDelegate:self];
//
//        if (result) {
//            NSLog(@"BaiduMapKit initialized success!");
//        } else {
//            NSLog(@"BaiduMapKit initialized failed!");
//        }
    }
    return _baiduMapMange;
}

- (BMKLocationService *)baiduLocationService {
    
    if (!_baiduLocationService) {
        
        _baiduLocationService = [BMKLocationService new];
        _baiduLocationService.delegate = self;
    }
    return _baiduLocationService;
}

- (BMKGeoCodeSearch *)baiduGeoCodeSearch {
    
    if (!_baiduGeoCodeSearch) {
        
        _baiduGeoCodeSearch = [BMKGeoCodeSearch new];
        _baiduGeoCodeSearch.delegate = self;
    }
    return _baiduGeoCodeSearch;
}

- (BMKReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption {
    
    if (!_reverseGeoCodeSearchOption) {
        _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    }
    return _reverseGeoCodeSearchOption;
}

- (LocationModel *)locationModel {
    
    if (!_locationModel) {
        
        _locationModel = [LocationModel new];
    }
    return _locationModel;
}

- (UserModel *)userModel {
    
    if (!_userModel) {
        
        _userModel = [UserModel new];
        _userModel.userToken = USER_TOKEN_DAUFAT;
    }
    return _userModel;
}

- (NSMutableDictionary *)scrollHeightDic {
    
    if (!_scrollHeightDic) {
        
        _scrollHeightDic = [[NSMutableDictionary alloc] init];
    }
    return _scrollHeightDic;
}

//初始化数据库工具
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
            
            [WeatherForecastLoader weatherForcastLoader:weatherForecastModel];
        }
    } else {
        
        [self.getDBHander insertToDB:weatherForecastModel];
        [WeatherForecastLoader weatherForcastLoader:weatherForecastModel];
    }
    
    return weatherForecastModel;
}


/* CoreDate

@synthesize managedObjectModel = _managedObjectModel;
- (NSManagedObjectModel *)managedObjectModel {
    
    if (!_managedObjectModel) {

        NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"Xinganmeng160414" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

@synthesize managedObjectContext = _managedObjectContext;
- (NSManagedObjectContext *)managedObjectContext {

    if (_managedObjectContext) {

        if (!self.persistentStoreCoordinator) {
            return nil;
        }

        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (NSPersistentStoreCoordinator *)persistentStroeCoordinator {

    if (!_persistentStoreCoordinator) {

        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

        NSURL * storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Xinganmeng160414.sqlite"];

        NSError * error = nil;

        NSString * failureReason = @"There was an error creating or loading the application's saved data.";

        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            dic[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dic[NSLocalizedFailureReasonErrorKey] = failureReason;
            dic[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dic];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSURL * )applicationDocumentsDirectory {

    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
*/

@end
