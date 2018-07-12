//
//  预警图标
//
//  WeatherWarningView.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/6.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "WeatherWarningView.h"

@interface WeatherWarningView ()

@property (nonatomic,strong) UILabel *      titleLabel;
@property (nonatomic,strong) UIImageView *  headImageView;

@end

@implementation WeatherWarningView

#pragma mark - Life cycle.

//- (instancetype)init {
//
//    if (self = [super init]) {
//
//        self.backgroundColor = [UIColor clearColor];
//        [self initUI];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        [self initUI];
    }
    return self;
}

#pragma mark - Handlers.

- (void)initUI {
    
    [self addSubview:self.headImageView];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.headImageButton];
    
    [self addSubview:self.airImageView];
    
    [self addSubview:self.airPressLabel];
}

#pragma mark - Getters and setters.

- (UIImageView *)headImageView {
    if (!_headImageView) {
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 2.5, 35, 30)];
    }
    return _headImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2.5, self.frame.size.width - 60, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"";
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _titleLabel;
}

- (UIButton *)headImageButton {
    
    if (!_headImageButton) {
        
        _headImageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 2.5, 35, 30)];
    }
    return _headImageButton;
}

- (UIImageView *)airImageView {
    
    if (!_airImageView) {
        
        _airImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        _airImageView.backgroundColor = [UIColor clearColor];
//        _airImageView.image = [UIImage imageNamed:@"sk_aqi"];
    }
    return _airImageView;
}

- (UILabel *)airPressLabel {
    
    if (!_airPressLabel) {
        
        _airPressLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 10, 160, 25)];
        _airPressLabel.textAlignment = NSTextAlignmentLeft;
        _airPressLabel.backgroundColor = [UIColor clearColor];
        _airPressLabel.textColor = [UIColor whiteColor];
        _airPressLabel.font = [UIFont systemFontOfSize:16];
    }
    return _airPressLabel;
}


@end
