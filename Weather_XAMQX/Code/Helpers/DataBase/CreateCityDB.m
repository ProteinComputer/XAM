//
//  CreateCityDB.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/6.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CreateCityDB.h"
#import "FMDB.h"
#import "NSString+CatchPath.h"

static NSString * kDataBaseName = @"cities.db";

@interface CreateCityDB ()

@property (nonatomic, strong) FMDatabaseQueue * databaseQueue;

@end

@implementation CreateCityDB

#pragma mark - Life cycle.


#pragma mark - Handlers.

- (BOOL)initCitiesDatabase {
    
    __block BOOL flag = NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        NSString * sqlPath = [[NSBundle mainBundle] pathForResource:@"g_region.sql" ofType:nil];
        
        NSError * error = nil;
        NSString * sqlContent = [NSString stringWithContentsOfFile:sqlPath encoding:NSUTF8StringEncoding error:&error];
        
        if (!error) {
            
            if ([db open]) {
                
                [db beginTransaction];
                
                if ([db executeStatements:sqlContent]) {
                    
                    NSLog(@"Cities.db has been initialzed!");
                    flag = YES;
                } else {
                    NSLog(@"Cities.db initialization failed!");
                    flag = NO;
                }
            } else {
                NSLog(@"db open failed!");
                flag = NO;
            }
        } else {
            NSLog(@"g_region.sql to content failed!");
            flag = NO;
        }
        [db commit];
    }];
    
    [self.databaseQueue close];
    
    return flag;
}

#pragma mark - Getters and setters.

- (FMDatabaseQueue *)databaseQueue {
    
    if (!_databaseQueue) {
        
        NSString * path = [NSString catchPathWithFileName:kDataBaseName];
        NSLog(@"cities.db path is %@.", path);
        
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _databaseQueue;
}

@end
