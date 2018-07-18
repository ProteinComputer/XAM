//
//  ForecastModel.h
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/18.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//
//  -> ForecastModel.h
//

#import "GenericModel.h"

@class CityInfoModel, CurrentWeatherForecastModel,HourForecastModel, WeatherLiveElementsModel;

@interface ForecastModel : GenericModel

/**
 *  城市信息
 */
@property (nonatomic, strong) CityInfoModel* cityInfoModel;
/**
 *  7天预报
 */
@property (nonatomic, strong) NSArray<CurrentWeatherForecastModel *> * cwfModelArray;
/**
 *  小时预报  精细化预报
 */
@property (nonatomic, strong) NSArray<HourForecastModel *> * forecastHour;
/**
 *  上下班天气
 */
//@property (nonatomic, strong) NSArray<OfficeWeatherModel*>*commuteWeather;
/**
 *  预警信号
 */
//@property (nonatomic, strong) NSArray<WarnimgModel*>*warns;
/**
 *  生活指数
 */
//@property (nonatomic, strong) NSArray<LifeIndexModel*>*lifeindex;
/**
 *  整点实况
 */
@property (nonatomic, strong) WeatherLiveElementsModel * wleModel;
/**
 *  背景图片
 */
//@property (nonatomic, strong) WeatherBackImageModel*weather_backgroud_image;

/**
 *  分享
 */
@property (nonatomic, copy) NSString * share;

//commuteWeather
//@property (nonatomic, strong) LxDocumentModel*shortTermPrediction;

///commuteWeather
//@property (nonatomic, strong) FTimeModel*ftime;

@end
