//
//  AppDelegate.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/3.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserModel.h"

@class CityModel, LocationModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *                                window;


@property (nonatomic, strong) UserModel *                               userModel;

@property (nonatomic, strong) CityModel *                               locationCityModel;

@property (nonatomic, strong) LocationModel *                           locationModel;


@property (nonatomic,strong) LKDBHelper *                               dbHelper;

@property (nonatomic, strong) NSMutableDictionary *                     scrollHeightDic;

@property (nonatomic, assign) BOOL                                      CURRNONETVC;

/* CoreData
@property (nonatomic, strong, readonly) NSManagedObjectContext * managedObjectContext;

@property (nonatomic, strong, readonly) NSManagedObjectModel * managedObjectModel;

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;
*/

- (LKDBHelper *)getDBHander;

@end

