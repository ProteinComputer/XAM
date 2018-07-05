//
//  UINavigationController子类，允许在隐藏导航栏或使用自定义后退按钮时识别交互式pop手势。
//
//  ZDNavigationController.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDNavigationController : UINavigationController


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated __attribute__((objc_requires_super));

@end
