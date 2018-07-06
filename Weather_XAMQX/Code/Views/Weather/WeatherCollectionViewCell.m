//
//  WeatheCollectionViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/5.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "WeatherCollectionViewCell.h"

#import "WeatherWarningView.h"
#import "WeatherLiveElementsTableViewCell.h"

static NSInteger kSection = 2;

@interface WeatherCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * noInfoView;

@property (nonatomic, strong) UILabel * noForecastLabel;

@property (nonatomic, strong) NSArray * forecastDataList;

@property (nonatomic, strong) UIButton * noInfoButton;

@end

@implementation WeatherCollectionViewCell

#pragma mark - Getters and setters.

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)noInfoView {
    
    if (!_noInfoView) {
        
        _noInfoView = [[UIView alloc] initWithFrame:self.bounds];
        _noInfoView.hidden = YES;
        [_noInfoView addSubview:self.noInfoButton];
    }
    return _noInfoView;
}

- (UIButton *)noInfoButton {
    
    if (!_noInfoButton) {
        
        _noInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _noInfoButton.frame = self.bounds;
        [_noInfoButton setTitle:@"无天气数据，请刷新" forState:UIControlStateNormal];
        [_noInfoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _noInfoButton.backgroundColor = [UIColor whiteColor];
        [_noInfoButton addTarget:self action:@selector(loadNewData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _noInfoButton;
}

#pragma mark - Handlers.

- (void)setHeaderRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self loadNewData];
    }];
}

-(void)warnningButtonAction:(UIButton *)sender {
    
    NSArray * tempArray = [self.weatherForecastModel.forcastContent JSONValue][@"warn"];
    
    NSDictionary * warningDic = [tempArray firstObject];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cityWeatherUpdate:withWarning:)]) {
        
        [_delegate cityWeatherUpdate:self withWarning:warningDic];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return kSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 0;
            break;
        case 1: {
            
            NSDictionary * resultDic = [self.weatherForecastModel.forcastContent JSONValue];
            
            NSArray * lifeIndexArray = resultDic[@"lifeindex"];
            
            if (lifeIndexArray != nil && lifeIndexArray.count > 0) {
                
                return 5;
            } else {
                return 4;
            }
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.weatherForecastModel.forcastContent.length < 100) {
        
        [self loadNewData];
        
        static NSString * kCellIdentifier = @"cell";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        
        if (indexPath.row == 0 && self.noForecastLabel == nil) {
            
            self.noForecastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 30)];
            self.noForecastLabel.backgroundColor = [UIColor clearColor];
            self.noForecastLabel.font = [UIFont systemFontOfSize:13];
            self.noForecastLabel.textColor = [UIColor whiteColor];
            self.noForecastLabel.textAlignment = NSTextAlignmentCenter;
            self.noForecastLabel.text = @"暂无数据，请下拉刷新";
            
            [cell addSubview:self.noForecastLabel];
        }
        
        self.noForecastLabel.hidden = YES;
        
        cell.backgroundColor = RGBA(128, 128, 128, 0.7);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        self.noForecastLabel.hidden = YES;
    }
    
    NSDictionary * resultDic = [self.weatherForecastModel.forcastContent JSONValue];
    
    if (indexPath.row == 1) {
        
        static NSString * kIdentifier = @"ForecastSKCell";
        
        WeatherLiveElementsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
        
        if (cell == nil) {
            
            cell = [WeatherLiveElementsTableViewCell new];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        NSDictionary * zdskDic = resultDic[@"zdsk"];
        NSDictionary * timeDic = resultDic[@"time"];
        
        /* 下面这段并没有执行 ？ */
        if (zdskDic != nil && [zdskDic allKeys].count > 5) {
            
            cell.weatherContentLabel.text = [NSString stringWithFormat:@"%@", zdskDic[@"three_status"]];
            
            cell.temperatureLabel.text = [NSString stringWithFormat:@"%@", zdskDic[@"temperature"]];
            
            cell.humidityLabel.text = [NSString stringWithFormat:@"%@%@", zdskDic[@"humidity"], @"%"];
            
            cell.rainLabel.text = [NSString stringWithFormat:@"%@mm", zdskDic[@"rain"]];
            
            cell.airPressureLabel.text = [NSString stringWithFormat:@"%@hPa", zdskDic[@"press"]];
            
            cell.windLabel.text = [NSString stringWithFormat:@"%@,%@m/s", zdskDic[@"wind_direction_cn"], zdskDic[@"wind_speed"]];
            
            cell.aqiLabel.text = [NSString stringWithFormat:@"AQI %@",zdskDic[@"air_aqi"]];
            cell.sunSetOneLabel.text = [NSString stringWithFormat:@"%@",zdskDic[@"sunset_one"]];
            cell.sunSetTwoLabel.text = [NSString stringWithFormat:@"%@",zdskDic[@"sunset_two"]];
            
            NSString * dateString = timeDic[@"issue_time"];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            
            NSDate *date=[dateFormatter dateFromString:dateString];
            
            NSDateFormatter *showDateFormatter=[[NSDateFormatter alloc]init];
            [showDateFormatter setDateFormat:@"HH:mm"];
            
            NSString *dateString2=[showDateFormatter stringFromDate:date];
            cell.timeLabel.text = [NSString stringWithFormat:@"兴安盟气象局%@发布",dateString2];
            
        } else {
            UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 30)];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter ;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor whiteColor];
            label.text = @"暂无数据";
            [cell addSubview:label];
        }
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0: {
            
                NSArray * tempArray = [self.weatherForecastModel.forcastContent JSONValue][@"warn"];
            
                NSDictionary * resultDic = [self.weatherForecastModel.forcastContent JSONValue];
            
                NSDictionary * zdskDic = resultDic[@"zdsk"];
            
                NSString * airAQI = zdskDic[@"air_api"];
            
                if (tempArray.count > 0 || airAQI.length != 0) {
                    return 35.0;
                } else {
                    return 0.0;
                }
            }
            break;
        case 1: {
            
            return 0.0;
            break;
        }
        default:
            break;
    }
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section != 0) return nil;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headerView.backgroundColor = [UIColor redColor];
    
    WeatherWarningView * warningView = [[WeatherWarningView alloc] initWithFrame:headerView.bounds];
    
    [headerView addSubview:warningView];
    
    NSArray * tempArray = [self.weatherForecastModel.forcastContent JSONValue][@"warn"];
    
    NSDictionary * warningDic = [tempArray firstObject];
    
    if (warningDic != nil) {
        
        [warningView.headImageButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"warnicon_%@.png", warningDic[@"type"]]] forState:UIControlStateNormal];
        
        [warningView.headImageButton addTarget:self action:@selector(warnningButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        warningView.headImageButton.hidden = YES;
    }
    
    NSDictionary * resultDic = [self.weatherForecastModel.forcastContent JSONValue];
    
    NSDictionary * zdskDic = resultDic[@"zdsk"];
    
    NSString * airAQI = zdskDic[@"air_aqi"];
    
    if (tempArray.count >0 || airAQI.length > 2) {
        
        warningView.airPressLabel.hidden = NO;
        
        warningView.airImageView.hidden = NO;
        
        warningView.airPressLabel.text = [NSString stringWithFormat:@"AQI %@", zdskDic[@"air_aqi"]];
    } else {
        
        warningView.airPressLabel.hidden = YES;
        warningView.airImageView.hidden = YES;
    }
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NSDictionary * resultDic = [self.weatherForecastModel.forcastContent JSONValue];
    
    NSDictionary * timeDic = resultDic[@"time"];
    
    NSString * dateString = timeDic[@"time"];
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate * date = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter * showDateFormatter = [NSDateFormatter new];
    [showDateFormatter setDateFormat:@"M月d日"];
    
    NSString * showDateString = [showDateFormatter stringFromDate:date];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    footerView.userInteractionEnabled = NO;
    
    UIView * divderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    divderView.backgroundColor = [UIColor grayColor];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, SCREEN_WIDTH - 90, 13)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@", showDateString, timeDic[@"nongli_year"], timeDic[@"montor_festival"]];
    
    [showDateFormatter setDateFormat:@"HH:mm更新"];
    
    NSString * updateTimeString = [showDateFormatter stringFromDate:date];
    
    UILabel * updateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 7, 65, 10)];
    updateTimeLabel.backgroundColor = [UIColor clearColor];
    updateTimeLabel.textAlignment = NSTextAlignmentRight;
    updateTimeLabel.textColor = [UIColor whiteColor];
    updateTimeLabel.font = [UIFont systemFontOfSize:10];
    updateTimeLabel.text = [NSString stringWithFormat:@"%@", updateTimeString];
    
    [footerView addSubview:divderView];
    [footerView addSubview:titleLabel];
    [footerView addSubview:updateTimeLabel];
    
    return footerView;
}

#pragma mark - UITableViewDelegate - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - Life cycle;

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tableView];
        
        [self addSubview:self.noInfoView];
        
        [self setHeaderRefresh];
    }
    return self;
}


- (void)setNoData:(BOOL)showNodata {
    
}

- (void)loadNewData {
    
}

- (void)readDBData {
    
}


@end
