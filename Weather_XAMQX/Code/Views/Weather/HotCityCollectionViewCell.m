//
//  HotCityCollectionViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "HotCityCollectionViewCell.h"

#import "HotCityModel.h"

@implementation HotCityCollectionViewCell

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
    
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.cityNameLabel];
}

- (void)loadDataAndFrame:(HotCityModel *)hotCityModel addState:(BOOL)isExist {
    
    if (isExist) {
        
        self.backgroundColor = THEMECOLOR;
        self.cityNameLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    self.cityNameLabel.text = hotCityModel.city_name;
}

#pragma mark - Getters and stters.

- (UILabel *)cityNameLabel {
    
    if (!_cityNameLabel) {
        
        _cityNameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.backgroundColor = [UIColor clearColor];
        _cityNameLabel.textColor = [UIColor whiteColor];
        _cityNameLabel.font = LABEL_FONT_13;
    }
    return _cityNameLabel;
}

@end
