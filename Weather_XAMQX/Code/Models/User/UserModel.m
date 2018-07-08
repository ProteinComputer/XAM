//
//  UserModel.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/7.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (BOOL)logined {
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"userId"].length > 0) {
        return YES;
    }
    
    return NO;
}

@end
