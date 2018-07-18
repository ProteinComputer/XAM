//
//  CityListTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/17.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CityListTableViewCell.h"

#import "CityModel.h"

@interface CityListTableViewCell ()

@property (nonatomic, strong) UILabel * shortNameLabel;

@property (nonatomic, strong) UILabel * fullNameLabel;

@end

@implementation CityListTableViewCell

#pragma mark - Life cycle.

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString * identifier = @"CityListTableViewCell";
    
    CityListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CityListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor clearColor];
    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55);
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CELL_SELECTED_COLOR;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initUI];
    }
    return self;
}

#pragma mark - Handlers.

- (void)initUI {
    
    [self addSubview:self.shortNameLabel];
    [self addSubview:self.fullNameLabel];
}

- (void)loadDataAndFrame:(CityModel *)cityModel {
    
    self.shortNameLabel.text = cityModel.short_name;
    self.fullNameLabel.text = cityModel.full_name;
}

#pragma Getters and setters.

- (UILabel *)shortNameLabel {
    
    if (!_shortNameLabel) {
        
        _shortNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 7, self.frame.size.width - 20, (self.frame.size.height - 20) / 2)];
        _shortNameLabel.font = LABEL_FONT_15;
        _shortNameLabel.textColor = [UIColor blackColor];
    }
    return _shortNameLabel;
}

- (UILabel *)fullNameLabel {
    
    if (!_fullNameLabel) {
        
        _fullNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + (self.frame.size.height - 20) / 2, self.frame.size.width - 20, (self.frame.size.height - 20) / 2)];
        _shortNameLabel.font = LABEL_FONT_13;
        _shortNameLabel.textColor = [UIColor darkGrayColor];
    }
    return _fullNameLabel;
}

@end
