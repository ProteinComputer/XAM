//
//  CustomBaseViewController.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/15.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBaseViewController : UIViewController

@property (nonatomic, strong) UIButton * leftButton;

@property (nonatomic, strong) UIButton * rightButton;


@property (nonatomic, strong) UIView * dividerView;

@property (nonatomic, strong) UIView * navigationView;

@property (nonatomic, strong) UIImageView * navigationImageView;


@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UILabel * baseTitleLabel;


@property (nonatomic, assign) BOOL noTabbar;


@property (nonatomic, strong) id model;

@property (nonatomic, strong) id parentModel;

@end
