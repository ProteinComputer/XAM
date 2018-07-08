//
//  UserModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/7.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString * userToken;

@property (nonatomic, copy) NSString * userId;

@property (nonatomic, copy) NSString * userName;

@property (nonatomic, copy) NSString * userPassword;

@property (nonatomic, copy) NSString * userLoginTime;

@property (nonatomic, copy) NSString * userRemark;

+ (BOOL)logined;

@end
