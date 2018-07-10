//
//  城市模型
//
//  CityModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, copy) NSString * oid;

@property (nonatomic, copy) NSString * pid;

@property (nonatomic, assign) int level;


@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * short_name;

@property (nonatomic, copy) NSString * full_name;

@property (nonatomic, copy) NSString * english_name;


@property (nonatomic, copy) NSString * post_code;

@property (nonatomic, copy) NSString * lat;

@property (nonatomic, copy) NSString * lng;


@property (nonatomic, copy) NSString * target_id;

@property (nonatomic, copy) NSString * target_cid;

@property (nonatomic, copy) NSString * target_pid;

@property (nonatomic, copy) NSString * target_nid;

@property (nonatomic, copy) NSString * target_sid;

@property (nonatomic, copy) NSString * target_real;


@property (nonatomic, copy) NSString * shortName_pinyin;

@property (nonatomic, copy) NSString * shortName_ShortPinyin;

@property (nonatomic, copy) NSString * indexChar;

@end
