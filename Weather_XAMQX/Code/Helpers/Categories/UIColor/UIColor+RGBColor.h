//
//  UIColor+RGBColor.h
//  VankeClub
//
//  Created by iXcoder on 13-7-25.
//  Copyright (c) 2013年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGBColor)

/*!
 *@brief        根据传入的值自动生成颜色(默认alpha=1)
 *@function     getColorWithRed:andGreen:andBlue:
 *@param        red         --红色值,超过1时按最大值255计算
 *@param        green       --绿色值,超过1时按最大值255计算
 *@param        blue        --蓝色值,超过1时按最大值255计算
 *@return       (UIColor)   --生成的颜色值
 */
+ (UIColor *)getColorWithRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;

/*!
 *@brief        根据十六进制串生成颜色值
 *@function     getColorWithHexString:
 *@param        hex         -- 十六进制颜色串(aabb11, 0xaabb11, 0xaabb11cc, #aabb11)
 *@return       (UIColor)   -- 生成的颜色值
 */
+ (UIColor *)getColorWithHexString:(NSString *)hex;

/*!
 *@brief        产生随机颜色
 *@function     randomColor
 *@param        (void)
 *@return       (UIColor)   -- 生成的颜色
 */
+ (UIColor *)randomColor;

@end
