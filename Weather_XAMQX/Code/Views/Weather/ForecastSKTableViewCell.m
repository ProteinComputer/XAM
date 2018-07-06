//
//  天气实况
//
//  ForecastSKTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/6.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "ForecastSKTableViewCell.h"

@interface ForecastSKTableViewCell ()

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

@property (nonatomic, strong) NSDictionary * zdskDicInfo;

@property (nonatomic, strong) NSDictionary * timeDicInfo;

@property (nonatomic, strong) NSArray * imageNameArray;

@end

@implementation ForecastSKTableViewCell

#pragma mark - Life cycle.

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initUI];
    }
    return self;
}

#pragma mark Handlers.

- (void)initUI {
    
    [self addSubview:self.weatherContentLabel];
    
    [self addSubview:self.temperatureLabel];
    
    [self addSubview:self.temperatureUnitLabel];
    
    [self addSubview:self.dividerLineView];
}

- (UILabel *)baseLabelWithFrame:(CGRect)aRect {
    
    UILabel*label = [[UILabel alloc] initWithFrame:aRect];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    return label;
}

- (UIImageView *)baseImageViewWithFrame:(CGRect)aRect imagePath:(NSString *)imageName{
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:aRect];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:imageName];
    
    return imageView;
}

- (void)initIconWithImageNameArray{
    
    for (int i = 0; i < self.imageNameArray.count; i++) {
        
        NSString * imageName = self.imageNameArray[i];
        
        [self addSubview:[self baseImageViewWithFrame:CGRectMake(10 + ((SCREEN_WIDTH - 20) / 2) * (i % 2), 110 + 5 + i / 2 * 30, 20, 30) imagePath:imageName]];
        
        CGRect rect = CGRectMake(10 + ((SCREEN_WIDTH - 20) / 2) * (i % 2) + 25, 110 + 5 + i / 2 * 30, (SCREEN_WIDTH - 20) / 2 - 30, 20);
        
        switch (i) {
                
            case 0:
                _rainLabel = [self baseLabelWithFrame:rect];
                _rainLabel.font = LABEL_FONT_15;
                [self addSubview:_rainLabel];
                break;
        
            case 1:
                _humidityLabel = [self baseLabelWithFrame:rect];
                _rainLabel.font = LABEL_FONT_15;
                [self addSubview:_humidityLabel];
                break;
                
            case 2:
                _airPressureLabel = [self baseLabelWithFrame:rect];
                _airPressureLabel.font = LABEL_FONT_15;
                [self addSubview:_airPressureLabel];
                break;
                
            case 3:
                _windLabel = [self baseLabelWithFrame:rect];
                _windLabel.font = LABEL_FONT_15;
                [self addSubview:_windLabel];
                break;
                
            case 4:
                _festivalLabel = [self baseLabelWithFrame:rect];
                _festivalLabel.font = LABEL_FONT_15;
                [self addSubview:_festivalLabel];
                break;
                
            case 5:
                _lunarCalendarLabel = [self baseLabelWithFrame:rect];
                _lunarCalendarLabel.font = LABEL_FONT_15;
                [self addSubview:_lunarCalendarLabel];
                break;
            default:
                break;
        }
    }
}

#pragma mark Getters and setters.

- (NSArray *)imageNameArray {
    
    if (!_imageNameArray) {
        
        _imageNameArray = @[@"sk_jiangyu",@"sk_shidu",@"sk_qiya",@"sk_feng",@"g_ic_weather_festival",@"g_ic_weather_calendar"];
    }
    return _imageNameArray;
}

- (UILabel *)weatherContentLabel {
    
    if (!_weatherContentLabel) {
        
        _weatherContentLabel = [self baseLabelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 20, 30)];
        _weatherContentLabel.textColor = [UIColor whiteColor];
    }
    return _weatherContentLabel;
}

- (UILabel *)temperatureLabel {
    
    if (_temperatureLabel) {
        
        _temperatureLabel = [self baseLabelWithFrame:CGRectMake(10, 30, SCREEN_WIDTH - 20, 70)];
        _temperatureLabel.font = CURRENT_TEMPERATURE_LABEL_FONT;
    }
    return _temperatureLabel;
}

- (UILabel *)temperatureUnitLabel {
    
    if (_temperatureUnitLabel) {
        
        CGSize temperatureLabelTextSize = [self.temperatureLabel.text sizeWithAttributedFontName:CURRENT_TEMPERATURE_LABEL_FONT];
        
        _temperatureUnitLabel = [self baseLabelWithFrame:CGRectMake(10 + temperatureLabelTextSize.width, 35, SCREEN_WIDTH - 20, 30)];
        _temperatureUnitLabel.font = CURRENT_TEMPERATURE_UNIT_LABEL_FONT;
        _temperatureUnitLabel.text = @"°C";
    }
    return _temperatureUnitLabel;
}

- (UIView *)dividerLineView {
    
    if (!_dividerLineView) {
        
        _dividerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200 - 0.5, SCREEN_WIDTH, 0.5)];
        _dividerLineView.backgroundColor = [UIColor whiteColor];
    }
    return _dividerLineView;
}

@end













