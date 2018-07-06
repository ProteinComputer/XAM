//
//  天气实况
//
//  WeatherLiveElementsTableViewCell.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/6.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherLiveElementsTableViewCell : UITableViewCell

/* 当前天气现象 */
@property (nonatomic,strong) UILabel *      weatherContentLabel;

/* 当前实况温度的单位符号 */
@property (nonatomic,strong) UILabel *      temperatureUnitLabel;

/* 当前实况温度 */
@property (nonatomic, strong) UILabel *      temperatureLabel;

@property (nonatomic, strong) UILabel *      humidityLabel;

@property (nonatomic, strong) UILabel *      visibilityLabel;

@property (nonatomic, strong) UILabel *      rainLabel;

@property (nonatomic, strong) UILabel *      airPressureLabel;

@property (nonatomic, strong) UILabel *      windLabel;

@property (nonatomic, strong) UILabel *      festivalLabel;

@property (nonatomic, strong) UILabel *      lunarCalendarLabel;

@property (nonatomic, strong) UIView *       dividerLineView;

@property (nonatomic, strong) UILabel *      timeLabel;

@property (nonatomic, strong) UILabel *      aqiLabel;

@property (nonatomic, strong) UILabel *      sunSetOneLabel;

@property (nonatomic, strong) UILabel *      sunSetTwoLabel;

@end
