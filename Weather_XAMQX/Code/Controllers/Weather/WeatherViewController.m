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
#import "CityWeatherCollectionViewCell.h"

static NSInteger kCollectionViewCounts = 11;

@interface WeatherViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, strong) UIView * showContentView;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * mutableArray;

//@property (nonatomic, strong) MarqueeLabel * marqueeLabel;

//@property (nonatomic, strong) DGActivityIndicatorView * activityIndicatorView;

@end


@implementation WeatherViewController


#pragma mark - Life cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - Getters and Setters.

- (UIPageControl *)pageControl {
    return _pageControl;
}

- (UIView *)showContentView {
    
    if (!_showContentView) {
        _showContentView = [[UIView alloc] initWithFrame:self.view.bounds];
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
        _collectionView.backgroundColor = [UIColor redColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        for (int i = 0; i <= kCollectionViewCounts; i++) {
            
            [_collectionView registerClass:[CityWeatherCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"WeatheCollectionViewCellIdentifier %d", i]];
        }
        
        [self.showContentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)mutableArray {
    return _mutableArray;
}


#pragma mark - UICollectionViewDelegate.

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

@end
