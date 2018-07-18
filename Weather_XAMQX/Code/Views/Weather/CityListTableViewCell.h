//
//  CityListTableViewCell.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/17.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityModel;

@interface CityListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)loadDataAndFrame:(CityModel *)cityModel;

@end
