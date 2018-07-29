//
//  用户已添加城市列表和天气预报
//
//  UserCityWeatherForecastTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/17.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//
//  -> LxCityManagerCell.h
//

#import "UserCityWeatherForecastTableViewCell.h"

#import "WeatherForecastModel.h"

@interface UserCityWeatherForecastTableViewCell ()

@property (nonatomic, strong) UIView * dividerView;

@end

@implementation UserCityWeatherForecastTableViewCell

#pragma mark - Life cycle.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

#pragma mark - Handlers.

- (void)initUI {
    
    [self addSubview:self.moveImageView];
    
    [self addSubview:self.weatherImageBackView];
    
    [self.weatherImageBackView addSubview:self.weatherImageView];
    
    [self addSubview:self.cityNameLabel];
    
    [self addSubview:self.currentForecastLabel];
    
    [self addSubview:self.currentTemperatureLabel];
    
    [self addSubview:self.locationImageView];
    
    [self addSubview:self.dividerView];
    
}

- (void)setWfModelForCell:(WeatherForecastModel *)wfModelForCell {
    
    if (wfModelForCell) {
        
        _wfModelForCell = wfModelForCell;
        
        NSDictionary * zdskDict = [_wfModelForCell.forcastContent JSONValue][@"zdsk"];

        NSDictionary * forecastDict =[[_wfModelForCell.forcastContent JSONValue][@"forecast"] firstObject];
        
        self.cityNameLabel.text = _wfModelForCell.name;
        self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"weathericon_day_%ld", [forecastDict[@"one_code"] integerValue]]];
        self.currentForecastLabel.text = [NSString stringWithFormat:@"%@%ld℃~%ld℃", forecastDict[@"one_code_cn"], [forecastDict[@"lowest"] integerValue], [forecastDict[@"highest"] integerValue]];
        
        self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%.1f°", [zdskDict[@"temperature"] floatValue]];
        
    } else {
        return;
    }
}

#pragma Getters and setters.

- (UIImageView *)moveImageView {
    
    if (!_moveImageView) {
        
//        _moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height / 2 - 10, 20, 20)];
        _moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
        _moveImageView.image = [UIImage imageNamed:@"citymanager_movecell"];
        _moveImageView.userInteractionEnabled = NO;
    }
    return _moveImageView;
}

- (UIView *)weatherImageBackView {
    
    if (!_weatherImageBackView) {
        
        _weatherImageBackView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moveImageView.frame) + 4, 30 - 18, 36, 36)];
        _weatherImageBackView.backgroundColor = CELL_SELECTED_COLOR;
        _weatherImageBackView.layer.cornerRadius = _weatherImageBackView.frame.size.width / 2;
        _weatherImageBackView.layer.masksToBounds = YES;
    }
    return _weatherImageBackView;
}

- (UIImageView *)weatherImageView {
    
    if (!_weatherImageView) {
        
        _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 28, 28)];
    }
    return _weatherImageView;
}

- (UILabel *)cityNameLabel {
    
    if (!_cityNameLabel) {
        
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weatherImageBackView.frame) + 10, 30 - 18, self.frame.size.width - CGRectGetMaxX(self.weatherImageView.frame) - 100, 15)];
        _cityNameLabel.font = LABEL_FONT_15_BOLD;
        _cityNameLabel.textColor = [UIColor darkGrayColor];
        _cityNameLabel.text = @"N/A";
    }
    return _cityNameLabel;
}

- (UILabel *)currentForecastLabel {
    
    if (!_currentForecastLabel) {
        
        _currentForecastLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weatherImageBackView.frame) + 10, 30 , self.frame.size.width - CGRectGetMaxX(self.weatherImageView.frame) - 100, 18)];
        _currentForecastLabel.font = LABEL_FONT_13;
        _currentForecastLabel.text = @"N/A N/A℃～N/A℃";
        _currentForecastLabel.textColor = [UIColor grayColor];
    }
    return _currentForecastLabel;
}

- (UILabel *)currentTemperatureLabel {
    
    if (!_currentTemperatureLabel) {
        
        _currentTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width , 30 - 18, 80, 36)];
        _currentTemperatureLabel.font = CURRENT_TEMPERATURE_LABEL_FONT_SIZE25;
        _currentTemperatureLabel.text = @"N/A°";
        _currentTemperatureLabel.textColor = [UIColor colorWithRed:0/255.0 green:147/255.0 blue:247/255.0 alpha:0.5];
    }
    return _currentTemperatureLabel;
}

- (UIImageView *)locationImageView {
    
    if (!_locationImageView) {
        
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
        _locationImageView.image = [UIImage imageNamed:@"location"];
        _locationImageView.hidden = YES;
    }
    return _locationImageView;
}

- (UIView *)dividerView {
    
    if (!_dividerView) {
        
        _dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, SCREEN_WIDTH, 0.5)];
        _dividerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _dividerView;
}

@end
