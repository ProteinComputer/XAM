//
//  TemperatureCurveTableViewCell.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/6.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureCurveTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray * weatherList;

@property (nonatomic, strong) UIColor * textColor;

- (instancetype)initWithFrame:(CGRect)frame forecastDataArray:(NSArray *)array;

- (instancetype)initWIthForecastDataArray:(NSArray *)array;

- (instancetype)initWithFrame:(CGRect)frame maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue;

- (void)setForecastDataArray:(NSArray *)array;

@end
