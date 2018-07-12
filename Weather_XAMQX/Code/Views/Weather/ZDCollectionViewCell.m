//
//  自定义CollectionViewCell
//
//  ZDCollectionViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/7.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "ZDCollectionViewCell.h"

@interface ZDCollectionViewCell ()

@end

@implementation ZDCollectionViewCell

#pragma mark - Life cycle.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = frame;
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - Handlers.

- (UIImageView *)baseImageViewWithFrame:(CGRect)frame imagePath:(NSString *)imagePath {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = [UIColor clearColor];
    
    if (imagePath != nil) {
        imageView.image = [UIImage imageNamed:imagePath];
    }
    
    return imageView;
}

- (UILabel *)baseLabelWithFrame:(CGRect)frame {
    
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = LABEL_FONT_15;
    
    return label;
}

- (void)initUI {
    
    [self addSubview:self.headImageView];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.contentLabel];
}

#pragma mark - Getters and Setters

- (UIImageView *)headImageView {
    
    if (!_headImageView) {
        
        _headImageView = [self baseImageViewWithFrame:CGRectMake(5, (self.frame.size.height - 40) / 2, 40, 40) imagePath:nil];
    }
    return _headImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [self baseLabelWithFrame:CGRectMake(50, 5, self.frame.size.width - 45, 20)];
        _titleLabel.font = LABEL_FONT_15_BOLD;
        _titleLabel.text = @"生活指数";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [self baseLabelWithFrame:CGRectMake(50, 25, self.frame.size.width - 45, 40)];
        _contentLabel.font = LABEL_FONT_13;
        _contentLabel.numberOfLines = 2;
        _contentLabel.text = @"指数说明";
    }
    return _contentLabel;
}

@end
