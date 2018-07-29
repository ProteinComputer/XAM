//
//  天气首页
//
//  WeatherViewController.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/4.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "WeatherViewController.h"

#import "WeatherForecastModel.h"
#import "WeatherCollectionViewCell.h"
#import "CityListManagerViewController.h"

static NSInteger kCollectionViewCounts = 11;

@interface WeatherViewController () <UICollectionViewDelegate, UICollectionViewDataSource, WeatherCollectionViewCellDelegate>

@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIView * showContentView;

@property (nonatomic, strong) DGActivityIndicatorView * activityIndicatorView;

@property (nonatomic, strong) UIImageView * locationImageView;

@property (nonatomic, strong) UIImageView * backgroundImageView;

@property (nonatomic, strong) UIView * backgroundMaskView;

@property (nonatomic, strong) UIVisualEffectView * visualEffectView;

@property (nonatomic, strong) NSMutableArray * cellIndentifierCellArray;

@property (nonatomic, strong) UIButton * addCityButton;

@end

@implementation WeatherViewController

{
    NSInteger scrollHeight[9];
}

#pragma mark - Life cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goForecastViewController:) name:GOTO_FORECAST_VIEWCONTROLLER object:nil];
    
    [self initUI];
    
    [self initDataBase];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    NSArray * dataArray = [dbHelper search:[WeatherForecastModel class] where:nil orderBy:@"isLocation DESC, addDate ASC" offset:0 count:10];
    
    if (self.userCityMutableArray) {
        
        [self.userCityMutableArray removeAllObjects];
    }
    
    self.userCityMutableArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    dataArray = nil;
    
    [self.collectionView reloadData];
    
    self.pageControl.numberOfPages = self.userCityMutableArray.count;
    self.pageControl.currentPage = self.pageControl.currentPage > self.userCityMutableArray.count ? 0 : self.pageControl.currentPage;
    
    [self.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH * self.pageControl.currentPage, 0)];
    
    if (self.pageControl.currentPage < self.userCityMutableArray.count) {
        
        NSString * identifier = self.cellIndentifierCellArray[self.pageControl.currentPage];
        
        WeatherCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage inSection:0]];
        
        WeatherForecastModel * weatherForecastModel = [self.userCityMutableArray objectAtIndex:self.pageControl.currentPage];
        cell.weatherForecastModel.oid = weatherForecastModel.oid;
        
        [self.collectionView registerClass:[WeatherCollectionViewCell class] forCellWithReuseIdentifier:self.cellIndentifierCellArray[self.pageControl.currentPage]];
        
        [cell readDBData];
        
        CGSize titleSize = [weatherForecastModel.name sizeWithAttributedFontName:self.baseTitleLabel.font];
        
        if ([weatherForecastModel.isLocation integerValue] == 1) {
            
            self.locationImageView.frame = CGRectMake((SCREEN_WIDTH - titleSize.width) / 2 - 26, 29, 26, 26);
            self.locationImageView.hidden = NO;
            
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        } else {
            
            self.locationImageView.hidden = YES;
            
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        }
        self.baseTitleLabel.text = weatherForecastModel.name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Handlers.

- (void)initUI {
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.backgroundImageView];
    
    [self.backgroundImageView addSubview:self.visualEffectView];
    
    [self.view addSubview:self.backgroundMaskView];
    
    [self.showContentView addSubview:self.collectionView];
    
    [self.view addSubview:self.showContentView];
    
    [self.view addSubview:self.addCityButton];
    
    [self.view addSubview:self.locationImageView];
    
    [self.view addSubview:self.baseTitleLabel];
    
    [self.view addSubview:self.pageControl];
    
    [self.view addSubview:self.activityIndicatorView];
    
}

- (void)initDataBase {
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    NSArray * dataArray = [dbHelper search:[WeatherForecastModel class] where:nil orderBy:@"isLocation DESC, addDate ASC" offset:0 count:10];
    
    if (self.userCityMutableArray) {
        
        [self.userCityMutableArray removeAllObjects];
    }
    
    self.userCityMutableArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    dataArray = nil;
    
    if (self.userCityMutableArray.count > self.pageControl.currentPage) {
        
        WeatherForecastModel * weatherForecastModel = [self.userCityMutableArray objectAtIndex:self.pageControl.currentPage];
        
        CGSize titleSize = [weatherForecastModel.name sizeWithAttributedFontName:self.baseTitleLabel.font];
        
        if ([weatherForecastModel.isLocation integerValue] == 1) {
            
            self.locationImageView.frame = CGRectMake((SCREEN_WIDTH - titleSize.width) / 2 - 26, 29, 26, 26);
            self.locationImageView.hidden = NO;
            
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        } else {
            
            self.locationImageView.hidden = YES;
            
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        }
        self.baseTitleLabel.text = weatherForecastModel.name;
    }
    
    self.pageControl.numberOfPages = self.userCityMutableArray.count;
}

- (void)loadNewData:(WeatherForecastModel *)cityForecastModel {
    
    NSString * dateTimeStr = [cityForecastModel.forcastContent JSONValue][@"time"][@"time"];
    
    NSDate * nowDate = [NSDate date];
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    
    NSDate * preUpdateDate = [dateFormatter dateFromString:dateTimeStr];
    
    if (dateTimeStr.length > 0 && [nowDate timeIntervalSinceDate:preUpdateDate] < 1 * 60 * 60) {
        return;
    }
    
    NSMutableDictionary * parametermDic = [[NSMutableDictionary alloc] init];
    
    [parametermDic setObject:@"true" forKey:@"time"];
    [parametermDic setObject:@"true" forKey:@"warn"];
    [parametermDic setObject:@"true" forKey:@"status"];
    [parametermDic setObject:@"true" forKey:@"forecast"];
    [parametermDic setObject:@"true" forKey:@"zdsk"];
    [parametermDic setObject:@"true" forKey:@"cityinfo"];
    [parametermDic setObject:@"true" forKey:@"lifeindex"];
    
    if (cityForecastModel != nil) {
        [parametermDic setObject:cityForecastModel.target_id forKey:@"cityid"];
    } else {
        NSLog(@"%s - loadNewData: logs date lost with %@", __func__, cityForecastModel.target_id);
    }
    
    [parametermDic setObject:SHARED_APPDELEGATE.userModel.userToken forKey:@"token"];
    
    [HTTPTool postWitPath:API_CITY_FORECAST params:parametermDic success:^(id json) {
        
        //存储数据
        NSString * aStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        cityForecastModel.forcastContent = aStr;
        
        LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
        [dbHelper updateToDB:cityForecastModel where:nil];
        
        [self reloadWeatherData];
        
    } failure:^(NSError *error) {
        NSLog(@"%s - loadNewData: HTTPTool  postWitPath error is %@", __func__, error);
    }];
}

- (void)reloadWeatherData {
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    NSArray * dataArray = [dbHelper search:[WeatherForecastModel class] where:nil orderBy:@"isLocation DESC, addDate ASC" offset:0 count:10];
    
    if (self.userCityMutableArray) {
        
        [self.userCityMutableArray removeAllObjects];
    }
    
    self.userCityMutableArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    dataArray = nil;
    
    [self.collectionView reloadData];
    
    self.pageControl.numberOfPages = self.userCityMutableArray.count;
    self.pageControl.currentPage = self.pageControl.currentPage > self.userCityMutableArray.count ? 0 : self.pageControl.currentPage;
    
    [self.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH * self.pageControl.currentPage, 0)];
    
    if (self.pageControl.currentPage < self.userCityMutableArray.count) {
        
        NSString * identifier = self.cellIndentifierCellArray[self.pageControl.currentPage];
        
        WeatherCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:self.pageControl.currentPage inSection:0]];
        
        WeatherForecastModel * weatherForecastModel = [self.userCityMutableArray objectAtIndex:self.pageControl.currentPage];
        
        cell.weatherForecastModel.oid = weatherForecastModel.oid;
        [cell readDBData];
        
        CGSize titleSize = [weatherForecastModel.name sizeWithAttributedFontName:self.baseTitleLabel.font];
        
        if ([weatherForecastModel.isLocation integerValue]==1) {
            
            self.locationImageView.frame = CGRectMake((SCREEN_WIDTH-titleSize.width)/2 - 26, 29, 26, 26);
            self.locationImageView.hidden = NO;
            
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        } else {
            
            self.locationImageView.hidden = YES;
            
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        }
        
        self.baseTitleLabel.text = weatherForecastModel.name;
    }
}

- (void)addFirstCity {
    
    NSString * tipsString = [NSString stringWithFormat:@"添加定位[%@] ?", SHARED_APPDELEGATE.locationCityModel.full_name];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"兴安盟气象" message:tipsString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self addLocationCity];
        
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addLocationCity {
    
    WeatherForecastModel * wfModel = [WeatherForecastModel new];
    
    if (SHARED_APPDELEGATE.locationCityModel && SHARED_APPDELEGATE.locationCityModel.target_id.length >0) {
        
        wfModel.oid =           SHARED_APPDELEGATE.locationCityModel.oid;
        wfModel.target_id =     SHARED_APPDELEGATE.locationCityModel.target_id;
        wfModel.name =          SHARED_APPDELEGATE.locationCityModel.name;
        wfModel.short_name =    SHARED_APPDELEGATE.locationCityModel.short_name;
        wfModel.full_name =     SHARED_APPDELEGATE.locationCityModel.full_name;
        wfModel.english_name =  SHARED_APPDELEGATE.locationCityModel.english_name;
        wfModel.post_code =     SHARED_APPDELEGATE.locationCityModel.post_code;
        wfModel.lat =           SHARED_APPDELEGATE.locationCityModel.lat;
        wfModel.lng =           SHARED_APPDELEGATE.locationCityModel.lng;
        
        wfModel.forcastContent = @"";
        wfModel.isLocation = @"0";
        wfModel.updateTime = @"";
        wfModel.isLocation = @"1";
    } else {
        
        wfModel.oid =@"152200";
        wfModel.target_id = @"10370";
        wfModel.name = @"兴安盟";
        wfModel.short_name = @"兴安盟";
        wfModel.full_name = @"内蒙古自治区,兴安盟";
        wfModel.english_name = @"Hinggan";
        wfModel.post_code = @"137400";
        wfModel.lat = @"46.076268";
        wfModel.lng = @"122.070317";

        wfModel.forcastContent = @"";
        wfModel.isLocation = @"0";
        wfModel.updateTime = @"";
        wfModel.isLocation = @"0";
    }
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    NSArray * array = [dbHelper search:[WeatherForecastModel class] where:@" isLocation = \'1\'" orderBy:nil offset:0 count:1];
    
    NSLog(@"array %@", array);
    
    if (array.count > 0) {
        
        WeatherForecastModel * tempWFModel = [array firstObject];
        
        if ([tempWFModel.oid integerValue] != [wfModel.oid integerValue]) {
            
            [dbHelper deleteToDB:[array firstObject]];
            [dbHelper insertToDB:wfModel];
            
            [self loadNewData:wfModel];
        } else {
            
            [dbHelper insertToDB:wfModel];
            [self loadNewData:wfModel];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)addCityManager:(UIButton *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    
    CityListManagerViewController * clmvController = [CityListManagerViewController new];
    
    [self.navigationController pushViewController:clmvController animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

//初始化 pageControl 定位图标 城市名称label
- (void)goForecastViewController:(NSNotification *)notify {
    
    NSInteger index = [notify.userInfo[@"index"] integerValue];
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.dbHelper;
    
    NSArray * array = [dbHelper search:[WeatherForecastModel class] where:nil orderBy:@"isLocation DESC, addDate ASC" offset:0 count:10];
    
    if (self.userCityMutableArray) {
        [self.userCityMutableArray removeAllObjects];
    }
    
    self.userCityMutableArray = [[NSMutableArray alloc] initWithArray:array];
    
    array = nil;
    
    self.pageControl.currentPage = index;
    
    [self.collectionView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
    
    if (index < self.userCityMutableArray.count) {
        
        NSString * identifier = self.cellIndentifierCellArray[self.pageControl.currentPage];
        
        WeatherCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        WeatherForecastModel * weatherForecastModel = [self.userCityMutableArray objectAtIndex:index];
        
        cell.weatherForecastModel.oid = weatherForecastModel.oid;
        [cell readDBData];
        
        CGSize titleSize = [weatherForecastModel.name sizeWithAttributedFontName:self.baseTitleLabel.font];
        
        if ([weatherForecastModel.isLocation integerValue] == 1) {
            
            self.locationImageView.frame = CGRectMake((SCREEN_WIDTH - titleSize.width) / 2 - 26, 29, 26, 26);
            self.locationImageView.hidden = NO;
            
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        } else {
            
            self.locationImageView.hidden = YES;
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        }
        self.baseTitleLabel.text = weatherForecastModel.name;
    }
}

#pragma mark - Getters and Setters.

- (DGActivityIndicatorView *)activityIndicatorView {
    
    if (!_activityIndicatorView) {
        
        _activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeCookieTerminator tintColor:[UIColor redColor]];
        _activityIndicatorView.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, 110, 110, 100);
        
        [_activityIndicatorView startAnimating];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            [self->_activityIndicatorView stopAnimating];
            [UIView animateWithDuration:0.5 animations:^{
                
                self.showContentView.hidden = NO;
            } completion:^(BOOL finished) {
                
                self.showContentView.hidden = NO;
            }];
        });
    }
    return _activityIndicatorView;
}

- (UIButton *)addCityButton {
    
    if (!_addCityButton) {
        
        _addCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addCityButton setFrame:CGRectMake(SCREEN_WIDTH - 34 - 5, 5 + BATTERY_BAR_HEIGHT, 34, 34)];
        [_addCityButton setBackgroundImage:[UIImage imageNamed:@"cityManage.png"] forState:UIControlStateNormal];
        [_addCityButton addTarget:self action:@selector(addCityManager:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCityButton;
}

- (UIView *)backgroundMaskView {
    
    if (!_backgroundMaskView) {
        
        _backgroundMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundMaskView.backgroundColor = RGBA(0, 0, 0, 0.0);
    }
    return _backgroundMaskView;
}

- (UIVisualEffectView *)visualEffectView {
    
    if (!_visualEffectView) {
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = self.backgroundImageView.bounds;
        _visualEffectView.alpha = 0.0f;
    }
    return _visualEffectView;
}

- (UIImageView *)backgroundImageView {
    
    if (!_backgroundImageView) {
        
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
        _backgroundImageView.image = [UIImage imageNamed:@"1080_1920_bg.jpg"];
    }
    return _backgroundImageView;
}

- (NSMutableArray *)cellIndentifierCellArray {
    
    if (!_cellIndentifierCellArray) {
        
        _cellIndentifierCellArray = [NSMutableArray array];
        
        for (int i = 0; i < 9; i++) {
            
            scrollHeight[i] = 0;
            
            [_cellIndentifierCellArray addObject:[NSString stringWithFormat:@"WeatheCollectionViewCellIdentifier%d",i]];
        }
    }
    return _cellIndentifierCellArray;
}

- (UIImageView *)locationImageView {
    
    if (!_locationImageView) {
        
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 29, 26, 26)];
        _locationImageView.image = [UIImage imageNamed:@"location_white.png"];
        _locationImageView.hidden = YES;
    }
    return _locationImageView;
}

- (UILabel *)baseTitleLabel {
    
    if (!_baseTitleLabel) {
        
        _baseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT)];
        _baseTitleLabel.font = LABEL_FONT_18_BOLD;
        _baseTitleLabel.textAlignment = NSTextAlignmentCenter;
        _baseTitleLabel.textColor = [UIColor whiteColor];
        _baseTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _baseTitleLabel;
}

- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, 10)];
        _pageControl.pageIndicatorTintColor = RGBA(128, 128, 128, 1);
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIView *)showContentView {
    
    if (!_showContentView) {
        _showContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -50)];
        _showContentView.hidden = YES;
    }
    return _showContentView;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        /* UICollectionViewFlowLayout */
        UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = self.showContentView.frame.size;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.minimumLineSpacing = 0.0;
        
        
        /* UICollectionView */
        _collectionView = [[UICollectionView alloc] initWithFrame:self.showContentView.bounds collectionViewLayout:flowLayout];
        
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        for (int i = 0; i <= kCollectionViewCounts; i++) {
            
            [_collectionView registerClass:[WeatherCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"WeatheCollectionViewCellIdentifier%d", i]];
        }
    }
    return _collectionView;
}

- (NSMutableArray *)userCityMutableArray {
    
    if (!_userCityMutableArray) {
        _userCityMutableArray = [NSMutableArray array];
    }
    return _userCityMutableArray;
}

#pragma mark - UICollectionViewDelegate.

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = self.cellIndentifierCellArray[indexPath.row];
    
    WeatherCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.delegate = self;
    
    if (!cell) {
        cell = [[WeatherCollectionViewCell alloc] init];
    }
    
    [cell setNeedsDisplay];
    cell.weatherForecastModel.oid = ((WeatherForecastModel *)self.userCityMutableArray[indexPath.row]).oid;
    [cell readDBData];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.userCityMutableArray != nil) {
        return self.userCityMutableArray.count;
    }
    
    return 0;
}

#pragma mark - WeatherCollectionViewCellDelegate

- (void)cityWeatherUpdate:(WeatherCollectionViewCell *)cityWeatherCollectionViewCell withForecastCityModel:(WeatherForecastModel *)weatherForecastModel {
    
    LKDBHelper * dbHelper = SHARED_APPDELEGATE.getDBHander;
    
    NSArray * tempArray = [dbHelper search:[WeatherForecastModel class] where:nil orderBy:@"isLocation DESC, addDate ASC" offset:0 count:10];
    
    if (self.userCityMutableArray) {
        [self.userCityMutableArray removeAllObjects];
    }
    
    self.userCityMutableArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    tempArray = nil;
}

//打开预警信息页面
- (void)cityWeatherUpdate:(WeatherCollectionViewCell *)cityWeatherCollectionViewCell withWarning:(NSDictionary *)warning {
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.hidesBottomBarWhenPushed = NO;
}


- (void)cityWeatherUpdate:(WeatherCollectionViewCell *)cityWeatherCollectionViewCell withScrollView:(UIScrollView *)scrollView {
    
    float tempAlpha = scrollHeight[self.pageControl.currentPage] / scrollView.contentSize.height;
    
    //设置模糊
    CGFloat effectViewAlpha = (tempAlpha * 1.5) > 0.5 ? 0.5 : (tempAlpha * 1.5);
    
    if (effectViewAlpha - self.visualEffectView.alpha > 0.05 || self.visualEffectView.alpha - effectViewAlpha > 0.05) {
        
        [UIView animateWithDuration:0.7 animations:^{
            
            self.visualEffectView.alpha = effectViewAlpha;
            
            self.backgroundMaskView.backgroundColor = RGBA(0, 0, 0, (tempAlpha * 1.5) > 0.4 ? 0.4 : (tempAlpha * 1.5));
        }];
    } else {
        
        self.visualEffectView.alpha = effectViewAlpha;
        
        self.backgroundMaskView.backgroundColor = RGBA(0, 0, 0, (tempAlpha * 1.5) > 0.4 ? 0.4 : (tempAlpha * 1.5));
    }
    
    scrollHeight[self.pageControl.currentPage] = scrollView.mj_offsetY;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
    
    if (index < self.userCityMutableArray.count) {
        
        NSString * identifier = self.cellIndentifierCellArray[index];
        
        WeatherCollectionViewCell * cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        
        WeatherForecastModel * weatherForecastModel = [self.userCityMutableArray objectAtIndex:index];
        
        cell.weatherForecastModel.oid = weatherForecastModel.oid;
        [cell readDBData];
        
        if (YES) {
            [cell loadNewData];
        }
        
        CGSize titleSize = [weatherForecastModel.name sizeWithAttributedFontName:self.baseTitleLabel.font];
        
        if ([weatherForecastModel.isLocation integerValue] == 1) {
            
            self.locationImageView.frame = CGRectMake((SCREEN_WIDTH - titleSize.width) / 2 - 26, 29, 26, 26);
            self.locationImageView.hidden = NO;
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        } else {
            
            self.locationImageView.hidden = YES;
            self.baseTitleLabel.frame = CGRectMake(0, BATTERY_BAR_HEIGHT, SCREEN_WIDTH, TITLE_LABEL_HEIGHT);
        }
        
        self.baseTitleLabel.text = weatherForecastModel.name;
        
        self.pageControl.currentPage = index;
        
        float tempAlpha = scrollHeight[self.pageControl.currentPage] / cell.tableView.contentSize.height;
        
        //设置模糊
        CGFloat effectViewAlpha = (tempAlpha * 1.5) > 0.5 ? 0.5 : (tempAlpha * 1.5);
        
        if (effectViewAlpha - self.visualEffectView.alpha > 0.05 || self.visualEffectView.alpha - effectViewAlpha > 0.05) {
            
            [UIView animateWithDuration:0.7 animations:^{
                
                self.visualEffectView.alpha = effectViewAlpha;
                
                self.backgroundMaskView.backgroundColor = RGBA(0, 0, 0, (tempAlpha * 1.5) > 0.4 ? 0.4 : (tempAlpha * 1.5));
            }];
        } else {
            
            self.visualEffectView.alpha = effectViewAlpha;
            
            self.backgroundMaskView.backgroundColor = RGBA(0, 0, 0, (tempAlpha * 1.5) > 0.4 ? 0.4 : (tempAlpha * 1.5));
        }
    }
}

@end
