//
//  用户已添加城市列表和天气预报
//
//  UserCityWeatherForecastTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/17.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "UserCityWeatherForecastTableViewCell.h"

#import "WeatherLiveElementsModel.h"
#import "CurrentWeatherForecastModel.h"

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

#pragma mark - UITabeleViewDelegate.

#pragma mark - UITabelViewDataSource.

#pragma mark - Handlers.

- (void)initUI {
    
    [self addSubview:self.moveImageView];
    
    [self addSubview:self.weatherImageBackVIew];
    
    [self.weatherImageBackVIew addSubview:self.weatherImageView];
    
    [self addSubview:self.cityNameLabel];
    
    [self addSubview:self.currentForecastLabel];
    
    [self addSubview:self.currentTemperatureLabel];
    
    [self addSubview:self.locationImageView];
    
    [self addSubview:self.dividerView];
}

- (void)loadCityName:(NSString *)cityName weatherLiveElementsModel:(WeatherLiveElementsModel *)wleModel currentWeatherForecastModel:(CurrentWeatherForecastModel *)cwfModel {
    
    self.cityNameLabel.text = cityName;
    self.wleModel = wleModel;
    
    if (!wleModel && !cwfModel) {
        return;
    }
    
    if ([cwfModel isKindOfClass:[NSDictionary class]]) {
        
        self.cwfModel = [[[CurrentWeatherForecastModel class] mj_objectArrayWithKeyValuesArray:cwfModel] copy];
    } else {
        
        self.cwfModel = (CurrentWeatherForecastModel *)cwfModel;
    }
    
    self.weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"weathericon_day_%ld", self.cwfModel.one_code]];
    
    self.currentForecastLabel.text = [NSString stringWithFormat:@"%@%ld℃~%ld℃", self.cwfModel.one_code_cn, self.cwfModel.lowest, self.cwfModel.highest];
    
    self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%.1f°", self.wleModel.temperature];
    
}

#pragma Getters and setters.

- (UIImageView *)moveImageView {
    
    if (!_moveImageView) {
        
        _moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 20) / 2, 20, 20)];
        _moveImageView.image = [UIImage imageNamed:@"citymanager_moveCell"];
        _moveImageView.userInteractionEnabled = NO;
    }
    return _moveImageView;
}

- (UIView *)weatherImageBackVIew {
    
    if (!_weatherImageBackVIew) {
        
        _weatherImageBackVIew = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moveImageView.frame) + 4, (self.frame.size.height - 36) / 2, 36, 36)];
        _weatherImageBackVIew.backgroundColor = CELL_SELECTED_COLOR;
        _weatherImageBackVIew.layer.cornerRadius = _weatherImageBackVIew.frame.size.width / 2;
        _weatherImageBackVIew.layer.masksToBounds = YES;
    }
    return _weatherImageBackVIew;
}

- (UIImageView *)weatherImageView {
    
    if (!_weatherImageView) {
        
        _weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 28, 28)];
    }
    return _weatherImageView;
}

- (UILabel *)cityNameLabel {
    
    if (!_cityNameLabel) {
        
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weatherImageBackVIew.frame) + 10, (self.frame.size.height - 40) / 2, self.frame.size.width - CGRectGetMaxX(self.weatherImageView.frame) - 100, 22)];
        _cityNameLabel.font = LABEL_FONT_15_BOLD;
        _cityNameLabel.textColor = [UIColor darkGrayColor];
    }
    return _cityNameLabel;
}

- (UILabel *)currentForecastLabel {
    
    if (!_currentForecastLabel) {
        
        _currentForecastLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.weatherImageBackVIew.frame) + 10, CGRectGetMaxY(self.cityNameLabel.frame), self.frame.size.width - CGRectGetMaxY(self.weatherImageView.frame) - 100, 18)];
        _currentForecastLabel.font = LABEL_FONT_15;
        _currentForecastLabel.textColor = [UIColor grayColor];
    }
    return _currentForecastLabel;
}

- (UILabel *)currentTemperatureLabel {
    
    if (!_currentTemperatureLabel) {
        
        _currentTemperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, (self.frame.size.height - 40) / 2, 80, 40)];
        _currentTemperatureLabel.font = CURRENT_TEMPERATURE_LABEL_FONT_SIZE25;
        _currentTemperatureLabel.textColor = [UIColor colorWithRed:0/255.0 green:147/255.0 blue:247/255.0 alpha:0.5];
    }
    return _currentTemperatureLabel;
}

- (UIImageView *)locationImageView {
    
    if (!_locationImageView) {
        
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, (self.frame.size.height - 20) / 2, 20, 20)];
        _locationImageView.image = [UIImage imageNamed:@"locationBtIcon"];
        _locationImageView.hidden = YES;
    }
    return _locationImageView;
}

- (UIView *)dividerView {
    
    if (!_dividerView) {
        
        _dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 61.5, SCREEN_WIDTH, 0.5)];
        _dividerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _dividerView;
}

- (WeatherLiveElementsModel *)wleModel {
    
    if (!_wleModel) {
        
        _wleModel = [WeatherLiveElementsModel new];
    }
    return _wleModel;
}

-(CurrentWeatherForecastModel *)cwfModel {
    
    if (!_cwfModel) {
        
        _cwfModel = [CurrentWeatherForecastModel new];
    }
    return _cwfModel;
}

@end
