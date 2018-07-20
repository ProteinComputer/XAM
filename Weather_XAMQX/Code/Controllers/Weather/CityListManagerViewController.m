//
//  城市列表
//
//  CityListManagerViewController.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/16.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//
//  -> LxForecastCityManagerViewController.m
//

#import "CityListManagerViewController.h"

#import "AddCityViewController.h"
#import "WeatherForecastModel.h"
#import "UserCityWeatherForecastTableViewCell.h"
#import "ForecastModel.h"

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeatherForecastModel * wfModel = [self.mutabelCityArray objectAtIndex:indexPath.row];
    
    NSDictionary * notificationDict = @{@"index":[NSString stringWithFormat:@"%ld", indexPath.row]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GOTO_FORECAST_VIEWCONTROLLER object:wfModel userInfo:notificationDict];
    
    [self leftButtonAction:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return UITableViewCellEditingStyleNone;

    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) return nil;
        
    UITableViewRowAction * tableViewRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"删除", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        WeatherForecastModel * wfModel = self.mutabelCityArray[indexPath.row];
        
        [SHARED_APPDELEGATE.getDBHander deleteToDB:wfModel];
        
        [self.mutabelCityArray removeObject:wfModel];
        
        [self.tabelView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    
    return @[tableViewRowAction];
}

#pragma mark - UITabelViewDataSource.

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mutabelCityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"UserCityWeatherForecastTableViewCell";
    
    UserCityWeatherForecastTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UserCityWeatherForecastTableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
    }
    
    WeatherForecastModel * wfModel = [self.mutabelCityArray objectAtIndex:indexPath.row];
    
    ForecastModel * cellForecastModel = [[ForecastModel class] mj_objectWithKeyValues:[wfModel.forcastContent JSONValue]];
    
    [cell loadCityName:wfModel.name weatherLiveElementsModel:cellForecastModel.wleModel currentWeatherForecastModel:[[cellForecastModel cwfModelArray] firstObject]];
    
    if ([wfModel.isLocation integerValue] == 1) {
        
        cell.locationImageView.hidden = NO;
        cell.moveImageView.hidden = YES;
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CELL_SELECTED_COLOR;
    
    return cell;
}

#pragma mark - Handlers.

- (void)initUI {
    
    self.baseTitleLabel.text = @"城市管理";

    [self.contentView addSubview:self.tabelView];
    
    [self.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

//加载当前用户的城市列表
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
    
    [self.tabelView addGestureRecognizer:self.longPressGestureRecognizer];
    
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

//城市列表长按方法
- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGR {
    
    UIGestureRecognizerState state = longPressGR.state;
    
    CGPoint location = [longPressGR locationInView:self.tabelView];
    
    NSIndexPath * indexPath = [self.tabelView indexPathForRowAtPoint:location];
    
    static UIView * snapshot = nil; //移动快照
    
    static NSIndexPath * targetIndexPath = nil; //手势目标下标位置
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan: { //定位城市不能移动
            
            WeatherForecastModel * wfModel = self.mutabelCityArray[indexPath.row];
            
            if ([wfModel.isLocation integerValue] != 1) {
                
                targetIndexPath = indexPath;
                
                UITableViewCell * cell = [self.tabelView cellForRowAtIndexPath:indexPath];
                
                snapshot = [self customSnapshotFromView:cell];
                
                __block CGPoint center = cell.center;
                
                snapshot.center = center;
                snapshot.alpha = 0.0;
                
                [self.tabelView addSubview:snapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                   
                    center.y = location.y;
                    
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint center = snapshot.center;
            center.y = location.y;
            
            snapshot.center = center;
            
            WeatherForecastModel * originWFModel = self.mutabelCityArray[indexPath.row];
            WeatherForecastModel * targetWFModel = self.mutabelCityArray[targetIndexPath.row];
            
            if ([originWFModel.isLocation integerValue] != 1 && [targetWFModel.isLocation integerValue] != 1 && indexPath && ![indexPath isEqual:targetIndexPath]) {
                
                [self.mutabelCityArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:targetIndexPath.row];
                [self.tabelView moveRowAtIndexPath:targetIndexPath toIndexPath:indexPath];
                
                targetIndexPath = indexPath;
            }
            break;
            
        }
        default: {
            
            UITableViewCell * cell = [self.tabelView cellForRowAtIndexPath:targetIndexPath];
            cell.hidden = NO;
            cell.alpha = 0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1;
                cell.backgroundColor = [UIColor whiteColor];
                
                NSTimeInterval yuanziTime = [NSDate date].timeIntervalSinceReferenceDate - self.mutabelCityArray.count;
                
                for (WeatherForecastModel * model in self.mutabelCityArray) {
                    
                    model.addDate = [NSDate dateWithTimeIntervalSince1970:yuanziTime++];
                    
                    [SHARED_APPDELEGATE.getDBHander updateToDB:model where:[NSString stringWithFormat:@"rowid = %ld", model.rowid]];
                }
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                targetIndexPath = nil;
                
            }];
            
            break;
        }
    }
}

//获取快照
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIView * snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = YES;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    snapshot.layer.shadowRadius = 0.0;
    snapshot.layer.shadowOpacity = 0.4;
    snapshot.backgroundColor = RGBA(22, 166, 246, 0.7);
    
    return snapshot;
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
