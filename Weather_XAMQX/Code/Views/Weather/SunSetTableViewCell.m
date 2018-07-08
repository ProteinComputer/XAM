//
//  SunSetTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/7.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "SunSetTableViewCell.h"

@interface SunSetTableViewCell ()

@property (nonatomic, strong) UIView * divideView;

@end

@implementation SunSetTableViewCell

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
    
    [self addSubview:self.divideView];
    
    [self addSubview:self.sunriseLabel];
    
    [self addSubview:self.sunsetLabel];
}

#pragma mark - Getters and setters.

- (UIView *)divideView {
    
    if (!_divideView) {
        
        _divideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        _divideView.backgroundColor = [UIColor grayColor];
    }
    return _divideView;
}

- (UILabel *)sunriseLabel {
    
    if (!_sunriseLabel) {
        
        _sunriseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, (SCREEN_WIDTH - 20) / 2, 20)];
        _sunriseLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _sunriseLabel;
}

- (UILabel *)sunsetLabel {
    
    if (!_sunsetLabel) {
        
        _sunsetLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 10, 10, (SCREEN_WIDTH - 20) / 2, 20)];
        _sunsetLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _sunriseLabel;
}

@end
