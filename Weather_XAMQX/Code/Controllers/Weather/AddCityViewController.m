//
//  AddCityViewController.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "AddCityViewController.h"

#import "CityModel.h"
#import "LocationServiceHandle.h"
#import "HotCityCollectionView.h"
#import "HotCityModel.h"
#import "WeatherForecastModel.h"
#import "CityListTableViewCell.h"
#import "CityListManagerViewController.h"
#import "WeatherForecastLoader.h"

@interface AddCityViewController () <UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, LocationServiceDelegate, HotCityCollectionViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UISearchController * searchController;

@property (nonatomic, strong) NSArray * pinyinAndCapitalLetterArray;

@property (nonatomic, strong) NSArray * placeNameArray;

@property (nonatomic, strong) NSArray * cityIndexArray;

@property (nonatomic, strong) NSMutableArray * hotCityArray;

@property (nonatomic, assign) BOOL isShowHotCityView;

@property (nonatomic, strong) LocationServiceHandle * locationServiceHandle;

@end

@implementation AddCityViewController

#pragma mark - Life cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Handlers.

- (void)initUI {
    
    self.baseTitleLabel.text = @"添加城市";
    
    self.contentView.hidden = NO;
    self.contentView.backgroundColor = RGBA(188, 212, 220, .3);
    [self.contentView addSubview:self.tableView];
    
    self.isShowHotCityView = YES;
    
//    [self addLeftButton];
    
    [self.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setRightButtonWithSingleTitle:@"定位" action:@selector(rightButtonAction:) target:self titleColor:[UIColor whiteColor] backgroundImage:[UIImage imageNamed:@"location.png"]];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)loadData {
    
    self.placeNameArray = [SHARED_APPDELEGATE.getDBHander search:[CityModel class] where:@"level = 2 or level = 3" orderBy:nil offset:0 count:5000];
    
    self.pinyinAndCapitalLetterArray = [self configPYCLArrayFrom:self.placeNameArray];
    
    [self loadHotCity];
}

- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction:(UIButton *)sender {
    
    self.locationServiceHandle.delegate = self;
    [self.locationServiceHandle initLocationService];
}

- (NSArray *)configPYCLArrayFrom:(NSArray *)array {
    
    NSInteger index = 0;
    
    NSMutableArray * mutablePYCLArray = [NSMutableArray array];
    
    NSMutableArray * mutableCityIndexArray = [NSMutableArray array];
    
    for (char c = 'A'; c < 'Z'; c++) {
        
        //当前字母
        NSString * letter = [NSString stringWithFormat:@"%c", c];
        
        if (![letter isEqualToString:@"I"] && [letter isEqualToString:@"O"] && ![letter isEqualToString:@"U"] && ![letter isEqualToString:@"V"]) {
            
            NSArray * tempArray = [self cityWithFilter:letter array:array];
            
            if (tempArray) {
                
                NSDictionary * tempDic = [self dictionaryIndexCharWithArray:tempArray indexChar:[letter uppercaseString] startIndex:index];
                
                [mutablePYCLArray addObject:tempDic];
                
                [mutableCityIndexArray addObject:letter];
                
                index += tempArray.count;
            }
        }
    }
    
    self.cityIndexArray = [mutableCityIndexArray copy];
    
    return [mutablePYCLArray copy];
}


/**
 根据谓词遍历条件得到数组

 @param filterString 谓词遍历条件
 @param predicateArray 将要遍历的数组
 @return 遍历后的数据
 */
- (NSArray<CityModel *> *)cityWithFilter:(NSString *)filterString array:(NSArray *)predicateArray {
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"indexChar == %@", filterString];
    
    NSArray * tempArray = [NSMutableArray arrayWithArray:[predicateArray filteredArrayUsingPredicate:predicate]];
    
    return tempArray;
}


/**
 创建由字符索引、坐标索引和数组的字典

 @param array 将要存储的数组
 @param indexChar 字符索引
 @param startIndex 坐标索引
 @return 存储后的字典
 */
- (NSDictionary *)dictionaryIndexCharWithArray:(NSArray *)array indexChar:(NSString *)indexChar startIndex:(NSInteger)startIndex {
    
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:array forKey:@"datas"];
    [tempDic setObject:indexChar forKey:@"indexChar"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld", startIndex] forKey:@"startIndex"];
    [tempDic setObject:[NSString stringWithFormat:@"%ld", array.count] forKey:@"count"];
    
    return tempDic;
}

- (void)loadHotCity {
    
    NSArray * tempArray = [SHARED_APPDELEGATE.getDBHander search:[HotCityModel class] where:@"" orderBy:nil offset:0 count:100];
    
    [self.hotCityArray removeAllObjects];
    
    for (HotCityModel * hotCityModel in tempArray) {
        
        if ([SHARED_APPDELEGATE.getDBHander searchSingle:[WeatherForecastModel class] where:[NSString stringWithFormat:@"oid = %ld", hotCityModel.city_oid] orderBy:nil]) {
            hotCityModel.addState = YES;
        } else {
            hotCityModel.addState = NO;
        }
        [self.hotCityArray addObject:hotCityModel];
    }
    
}

- (BOOL)addCityHandle:(CityModel *)cityModel {
    
    WeatherForecastModel * currentWFModel = [[WeatherForecastModel alloc] initWithCityModel:cityModel];
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    WeatherForecastModel * exsitWFModel = [[WeatherForecastModel alloc] initWithCityModel:[dbHelper searchSingle:[WeatherForecastModel class] where:[NSString stringWithFormat:@"oid = '%@' and isLocation = 0", currentWFModel.oid] orderBy:nil]];

    if (!exsitWFModel) {
        
        NSArray * array = [dbHelper search:[WeatherForecastModel class] where:nil orderBy:nil offset:0 count:100];
        
        if (array.count < 10) {
            
            BOOL addSuccess = [dbHelper insertToDB:currentWFModel];
            
            if (addSuccess) {
                
                [SVProgressHUD showSuccessWithStatus:@"添加成功!"];
                
                NSArray * vcArray = [self.navigationController viewControllers];
                
                for (UIViewController * vc in vcArray) {
                    
                    if ([vc isKindOfClass:[CityListManagerViewController class]]) {
                        [vc removeFromParentViewController];
                    }
                }
                
                [SVProgressHUD showWithStatus:@"正在添加!"];
                
                NSArray * array = [SHARED_APPDELEGATE.getDBHander search:[WeatherForecastModel class] where:nil orderBy:@"isLocation, addDate ASC" offset:0 count:10];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GOTO_FORECAST_VIEWCONTROLLER object:currentWFModel userInfo:@{@"index" : [NSString stringWithFormat:@"%ld", array.count - 1]}];
                
                [WeatherForecastLoader weatherForcastLoader:currentWFModel];
                return YES;
            }
        } else {
            [SVProgressHUD showSuccessWithStatus:@"城市数量已达上限，请删除后再添加！"];
            return NO;
        }
    } else {
        [SVProgressHUD showSuccessWithStatus:@"城市已存在！"];
    }
    return NO;
}

#pragma mark - UITableViewDelegate.

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0 && self.isShowHotCityView) ? (50 + 40 * self.hotCityArray.count / 4 + ((self.hotCityArray.count % 4 == 0) ? 0 : 1)) : 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (section == 0 && self.isShowHotCityView) ? (50 + 40 * self.hotCityArray.count / 4 + ((self.hotCityArray.count % 4 == 0) ? 0 : 1)) : 30)];
    
    headerView.backgroundColor = [UIColor clearColor];
    
    //索引
    NSDictionary * titleDic = self.pinyinAndCapitalLetterArray[section];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, headerView.frame.size.height - 30, headerView.frame.size.width, 30)];
    titleLabel.text = titleDic[@"indexChar"];
    
    [headerView addSubview:titleLabel];
    titleLabel.textColor = [UIColor darkGrayColor];
    
    if (self.isShowHotCityView && section == 0) {
        
        //热门城市
        UILabel * hotNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, 30)];
        hotNameLabel.text = @"热门城市";
        hotNameLabel.font = LABEL_FONT_15;
        hotNameLabel.textColor = [UIColor darkGrayColor];
        
        UIView * hotCityContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, headerView.frame.size.width, headerView.frame.size.height - 40)];
        hotCityContentView.backgroundColor = [UIColor clearColor];
        
        [headerView addSubview:hotNameLabel];
        [headerView addSubview:hotCityContentView];
        
        HotCityCollectionView * hotCityCollectionView = [[HotCityCollectionView alloc] initWithFrame:CGRectMake(10, 0, hotCityContentView.bounds.size.width - 30, hotCityContentView.bounds.size.height)];
        hotCityCollectionView.delegate = self;
        hotCityCollectionView.hotCityArray = [self.hotCityArray copy];
        
        [hotCityContentView addSubview:hotCityCollectionView];
        
    }
    
    return headerView;
}


#pragma mark - UITabelViewDataSource.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pinyinAndCapitalLetterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * tempArray = self.pinyinAndCapitalLetterArray[section][@"datas"];
    return tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * tempArray = self.pinyinAndCapitalLetterArray[indexPath.section][@"datas"];
    
    CityModel * cityModel = tempArray[indexPath.row];
    
    CityListTableViewCell * cell = [CityListTableViewCell cellWithTableView:tableView];
    
    [cell loadDataAndFrame:cityModel];
    
    return cell;
}

//添加索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.cityIndexArray;
}

//索引触碰事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * tempArray = self.pinyinAndCapitalLetterArray[indexPath.section][@"datas"];
    
    CityModel * cityModel = tempArray[indexPath.row];
    
    [self addCityHandle:cityModel];
}

#pragma mark - Getters and setters.

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UISearchController *)searchController {
    
    if (!_searchController) {
        
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.frame = CGRectMake(0, 100, SCREEN_WIDTH, 44);
        _searchController.searchBar.barTintColor = CONTENTVIEW_BACKGROUND_COLOR;
        
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        
        _searchController.dimsBackgroundDuringPresentation = NO;
    }
    return _searchController;
}

- (NSArray *)placeNameArray {
    
    if (!_placeNameArray) {
        
        _placeNameArray = [NSArray array];
    }
    return _placeNameArray;
}

- (NSArray *)pinyinAndCapitalLetterArray {
    
    if (!_pinyinAndCapitalLetterArray) {
        
        _pinyinAndCapitalLetterArray = [NSArray array];
    }
    return _pinyinAndCapitalLetterArray;
}

- (NSArray *)cityIndexArray {
    
    if (!_cityIndexArray) {
        
        _cityIndexArray = [NSArray array];
    }
    return _cityIndexArray;
}

- (LocationServiceHandle *)locationServiceHandle {
    
    if (!_locationServiceHandle) {
        
        _locationServiceHandle = [LocationServiceHandle new];
    }
    return _locationServiceHandle;
}

- (NSMutableArray *)hotCityArray {
    
    if (!_hotCityArray) {
        _hotCityArray = [NSMutableArray array];
    }
    return _hotCityArray;
}

@end
