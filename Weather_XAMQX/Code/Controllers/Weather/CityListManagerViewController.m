//
//  城市列表
//
//  CityListManagerViewController.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "CityListManagerViewController.h"

#import "AddCityViewController.h"
#import "WeatherForecastModel.h"
#import "UserCityWeatherForecastTableViewCell.h"

@interface CityListManagerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * mutabelCityArray;

@property (nonatomic, strong) UITableView * tabelView;

@property (nonatomic, strong) UILongPressGestureRecognizer * longPressGestureRecognizer;

@end

@implementation CityListManagerViewController

#pragma mark - Life cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabeleViewDelegate.

#pragma mark - UITabelViewDataSource.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mutabelCityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"UserCityWeatherForecastTableViewCell";
    
    UserCityWeatherForecastTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UserCityWeatherForecastTableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 62)];
    }
    
    WeatherForecastModel * wfModel = [self.mutabelCityArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Handlers.

- (void)initUI {
    
    self.baseTitleLabel.text = @"城市管理";
    self.contentView.hidden = NO;
    
    [self.contentView addSubview:self.tabelView];
    
    [self addLeftButton];
    [self.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setRightButtonWithSingleTitle:@"增加" action:@selector(rightButtonAction:) target:self titleColor:[UIColor whiteColor] backgroundImage:[UIImage imageNamed:@"add"]];
    

}

- (void)loadData {
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    [self.mutabelCityArray removeAllObjects];
    
    WeatherForecastModel * wfLocationModel = [dbHelper searchSingle:[WeatherForecastModel class] where:@"isLocation = 1" orderBy:@"addDate DESC"];
    
    if (wfLocationModel) {
        
        [self.mutabelCityArray addObject:wfLocationModel];
    }
    
    NSArray * temArray = [dbHelper search:[WeatherForecastModel class] where:@"isLocation != 1" orderBy:@"addDate ASC" offset:0 count:100];
    
    if (temArray) {
        
        [self.mutabelCityArray addObjectsFromArray:temArray];
    }
    
}

- (void)leftButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction:(UIButton *)sender {
    
    if (self.mutabelCityArray.count >= 9) {
        
        [SVProgressHUD showSuccessWithStatus:@"城市数量已达上限，请删除后再添加！"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    AddCityViewController * addCityViewController = [AddCityViewController new];
    
    [self.navigationController pushViewController:addCityViewController animated:YES];
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGR {
    
}

#pragma mark - Getters and setters.

- (NSMutableArray *)mutabelCityArray {
    
    if (!_mutabelCityArray) {
        
        _mutabelCityArray = [NSMutableArray array];
    }
    return _mutabelCityArray;
}

- (UITableView *)tabelView {
    
    if (!_tabelView) {
        
        _tabelView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
        _tabelView.allowsSelectionDuringEditing = YES;
        _tabelView.backgroundColor = [UIColor whiteColor];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        
        [_tabelView addGestureRecognizer:self.longPressGestureRecognizer];
    }
    return _tabelView;
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer {
    
    if (!_longPressGestureRecognizer) {
        
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizer:)];
    }
    return _longPressGestureRecognizer;
}

@end
