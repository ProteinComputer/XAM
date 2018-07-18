//
//  CityManagerTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CityManagerTableViewCell.h"

@interface CityManagerTableViewCell ()

@property (nonatomic, strong) UIView * dividerView;

@end

@implementation CityManagerTableViewCell

#pragma mark - Life cycle.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        
    }
    return self;
}

#pragma mark - UIViewHierarchy

- (void)layoutSubviews {
    
    if (self.locationImageView.hidden) {
        
        self.cityNameLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH, self.bounds.size.height);
    } else {
        
        self.cityNameLabel.frame = CGRectMake(50, 0, SCREEN_WIDTH, self.bounds.size.height);
    }
}

#pragma mark - Handlers.

- (void)initUI {
    
    [self addSubview:self.locationImageView];
    
    [self addSubview:self.cityNameLabel];
    
    [self addSubview:self.dividerView];
}

#pragma mark - Getters and setters.

- (UIImageView *)locationImageView {
    
    if (!_locationImageView) {
        
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.bounds.size.height - 30) / 2, 30, 30)];
        _locationImageView.backgroundColor = [UIColor clearColor];
        _locationImageView.image = [UIImage imageNamed:@"location"];
        _locationImageView.hidden = YES;
    }
    return _locationImageView;
}

- (UILabel *)cityNameLabel {
    
    if (!_cityNameLabel) {
        
        _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, self.bounds.size.height)];
        _cityNameLabel.textColor = [UIColor blackColor];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.backgroundColor = [UIColor clearColor];
        _cityNameLabel.font = LABEL_FONT_15;
    }
    return _cityNameLabel;
}

- (UIView *)dividerView {
    
    if (!_dividerView) {
        
        _dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        _dividerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _dividerView;
}

@end
