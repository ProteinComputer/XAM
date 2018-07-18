//
//  城市管理
//
//  CityManagerViewController.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CityManagerViewController.h"

#import "WeatherForecastModel.h"
#import "CityManagerTableViewCell.h"

@interface CityManagerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * headerView;

@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIView * divider;

@end

@implementation CityManagerViewController

#pragma mark - Life cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    NSArray * tempArray = [dbHelper search:[WeatherForecastModel class] where:@"" orderBy:@"isLocation DESC, addDate ASC" offset:0 count:10];
    
    self.mutableCityArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    switch (section) {
            
        case 0:
            self.titleLabel.text = @"左滑编辑";
            break;
            
        default:
            self.titleLabel.text = @"N/A";
            break;
    }
    
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.divider];
    
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView * dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    dividerView.backgroundColor = [UIColor whiteColor];
    
    [self.footerView addSubview:dividerView];
    
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeatherForecastModel * wfModel = [self.mutableCityArray objectAtIndex:indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cityManagerViewController:reSelectedCityModel:selectedIndex:)]) {
        
        [self.delegate cityManagerViewController:self reSelectedCityModel:wfModel selectedIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return self.mutableCityArray.count;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"cellIdentifier";
    
    CityManagerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[CityManagerTableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    }
    
    WeatherForecastModel * wfModel = [self.mutableCityArray objectAtIndex:indexPath.row];
    
    cell.cityNameLabel.text = wfModel.full_name;
    
    if ([wfModel.isLocation integerValue] == 1) {
        
        cell.locationImageView.hidden = NO;
    } else {
        
        cell.locationImageView.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGBA(22, 166, 246, 0.7);
    
    [cell layoutSubviews];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.mutableCityArray.count) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (self.mutableCityArray.count <= 1) {
            
            GCDiscreetNotificationView * gcdnView = [[GCDiscreetNotificationView alloc] initWithText:@"N/A" inView:tableView];
            [gcdnView setTextLabel:@"至少保留一个城市"];
            [gcdnView showAndDismissAfter:2];
            
            [tableView reloadData];
        } else {
            
            LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
            
            WeatherForecastModel * wfModel = [self.mutableCityArray objectAtIndex:indexPath.row];
            
            BOOL result = [dbHelper deleteToDB:wfModel];
            if (result) {
                
                [self.mutableCityArray removeObjectAtIndex:indexPath.row];
                
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView reloadData];
            }
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {}
}

//未完成
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Handlers.

- (void)initUI {
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Getters and setters.

- (UITableView *)tableView {
    
    if (_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)mutableCityArray {
    
    if (!_mutableCityArray) {
        
        _mutableCityArray = [NSMutableArray array];
    }
    return _mutableCityArray;
}

- (UIView *)headerView {
    
    if (_headerView) {
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        _headerView.backgroundColor = [UIColor getColorWithHexString:@"#eeeeee"];
    }
    return _headerView;
}

- (UIView *)footerView {
    
    if (!_footerView) {
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        _footerView.backgroundColor = [UIColor getColorWithHexString:@"#dddddd"];
    }
    return _footerView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 12, 35)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor getColorWithHexString:@"#808080"];
        _titleLabel.font = LABEL_FONT_15;
    }
    return _titleLabel;
}

- (UIView *)divider {
    
    if (!_divider) {
        
        _divider = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height - 0.5, SCREEN_WIDTH, 0.5)];
        _divider.backgroundColor = [UIColor whiteColor];
    }
    return _divider;
}

@end
