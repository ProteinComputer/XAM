//
//  NSString+CatchPath.m
//  原生Sqllite
//
//  Created by Jack on 2018/6/21.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "NSString+CatchPath.h"

@implementation NSString (CatchPath)

+ (NSString *)catchPathWithFileName:(NSString *)fileName {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
}

@end
