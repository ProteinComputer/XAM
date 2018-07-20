//
//  CustomBaseViewController.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/15.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CustomBaseViewController.h"

@interface CustomBaseViewController ()

@end

@implementation CustomBaseViewController

#pragma mark - Life cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - Handlers.

- (void)loadUI {
    
    self.noTabbar = YES;
    self.view.backgroundColor = CONTENTVIEW_BACKGROUND_COLOR;
    self.view.clipsToBounds = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.contentView];
    
    [self.view addSubview:self.navigationView];
    
    [self.navigationView addSubview:self.baseTitleLabel];
    
    [self.navigationView addSubview:self.dividerView];
    
    [self.navigationView addSubview:self.leftButton];
    
    [self.navigationView addSubview:self.rightButton];
    
}

#pragma mark - Getters and setters.

- (UIView *)navigationView {
    
    if (!_navigationView) {
        
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BATTERY_BAR_HEIGHT + TITLE_LABEL_HEIGHT)];
        _navigationView.backgroundColor = THEMECOLOR;
    }
    return _navigationView;
}

- (UILabel *)baseTitleLabel {
    
    if (!_baseTitleLabel) {
        
        _baseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT)];
        _baseTitleLabel.backgroundColor = THEMECOLOR;
        _baseTitleLabel.font = LABEL_FONT_18_BOLD;
        _baseTitleLabel.textAlignment = NSTextAlignmentCenter;
        _baseTitleLabel.textColor = LABEL_TEXTCOLOR_DARKBLACK;
        _baseTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _baseTitleLabel;
}

- (UIView *)dividerView {
    
    if (!_dividerView) {
        
        _dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationView.frame.size.height - 1, self.navigationView.frame.size.width, 1)];
        _dividerView.backgroundColor = DIVIDER_BACKGROUND_COLOR;
    }
    return _dividerView;
}

- (UIView *)contentView {
    
    if (!_contentView) {
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, BATTERY_BAR_HEIGHT + TITLE_LABEL_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - (BATTERY_BAR_HEIGHT - 1 + TITLE_LABEL_HEIGHT + (self.noTabbar ? 0 : 50)))];
        _contentView.backgroundColor = CONTENTVIEW_BACKGROUND_COLOR;
    }
    return _contentView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(5, BATTERY_BAR_HEIGHT, 44, 44);
        [_leftButton setTitleColor:RGBA(22, 116, 246, 1) forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    
    if (!_rightButton) {
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(SCREEN_WIDTH - 44 - 5, BATTERY_BAR_HEIGHT, 44, 44);
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    }
    return _rightButton;
}

@end
