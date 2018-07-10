//
//  TemperatureCurveTableViewCell.m
//  Weather_XAMQX
//
//  Created by Jack on 2018/7/6.
//  Copyright © 2018年 com.dyfc. All rights reserved.
//

#import "TemperatureCurveTableViewCell.h"

@interface Extremum : NSObject

@property (nonatomic, assign) CGFloat max;

@property (nonatomic, assign) CGFloat min;

@end

@implementation Extremum


@end

@interface TemperatureCurveTableViewCell ()

@property (nonatomic, assign) CGFloat minValue;

@property (nonatomic, assign) CGFloat maxValue;

@end

@implementation TemperatureCurveTableViewCell

#pragma mark Life cycle.

- (instancetype)initWithFrame:(CGRect)frame forecastDataArray:(NSArray *)array {
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        self.clearsContextBeforeDrawing = YES;
        self.weatherList = array;
        
        Extremum * extremum = [self getExtremumWithArray:self.weatherList];
        
        self.maxValue = extremum.max;
        self.minValue = extremum.min;
    }
    return self;
}

- (instancetype)initWIthForecastDataArray:(NSArray *)array {
    
    self = [super init];
    
    if (self) {
        
        self.clearsContextBeforeDrawing = YES;
        self.weatherList = array;
        
        Extremum * extremum = [self getExtremumWithArray:self.weatherList];
        
        self.maxValue = extremum.max;
        self.minValue = extremum.min;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame maxValue:(CGFloat)maxValue minValue:(CGFloat)minValue {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clearsContextBeforeDrawing = YES;
        self.textColor = [UIColor whiteColor];
        self.maxValue = maxValue;
        self.minValue = minValue;
    }
    return self;
}

#pragma mark - Handlers.


/**
 计算数据的极值

 @param array 预报数组
 @return 极值模型
 */
- (Extremum *)getExtremumWithArray:(NSArray *)array {
    
    Extremum * extremum = [Extremum new];
    
    if (array.count > 0) {
        
        extremum.max = [[array firstObject][@"highest"] floatValue];
        extremum.min = [[array firstObject][@"lowest"] floatValue];
    }
    
    for (NSDictionary * itemDic in array) {
        
        if ([itemDic[@"highest"] floatValue] > extremum.max) {
            extremum.max = [itemDic[@"highest"] floatValue];
        }
        
        if ([itemDic[@"lowest"] floatValue] < extremum.min) {
            extremum.min = [itemDic[@"lowest"] floatValue];
        }
    }
    
    extremum.max += 9;
    extremum.min -= 9;
    
    return extremum;
}

- (void)setForecastDataArray:(NSArray *)array {
    
    self.clearsContextBeforeDrawing = YES;
    
    self.weatherList = array;
    
    Extremum * extremum = [self getExtremumWithArray:self.weatherList];
    
    self.maxValue = extremum.max;
    self.minValue = extremum.min;
}

- (NSInteger)timeZone {
    
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"H";
    
    NSString * dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSInteger hour = [dateStr integerValue];
    
    if (hour >= 0 && hour < 8) {
        return 0;
    } else if (hour >=8 && hour < 20) {
        return 1;
    } else if (hour >= 20 && hour <= 23) {
        return 2;
    }
    return 1;
}

/**
 绘制文字

 @param text 被绘制的文字
 @param frame 绘制大小
 @param color 绘制颜色
 */
- (void)drawText:(NSString *)text rect:(CGRect)frame color:(UIColor *)color {
    
    [color setFill];
    
    NSMutableParagraphStyle * paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                 LABEL_FONT_15,
                                 NSFontAttributeName,
                                 paragraphStyle,
                                 NSParagraphStyleAttributeName,
                                 color,
                                 NSForegroundColorAttributeName,
                                 nil];
    [text drawInRect:frame withAttributes:attributes];
}

/**
 绘制白色圆点

 @param content 绘制上下文对象
 @param aRect 圆点矩形
 @param color 圆的颜色
 */
- (void)drawPoint:(CGContextRef)content rect:(CGRect)aRect fillColor:(UIColor *)color {
    
    CGContextSetFillColorWithColor(content, [color CGColor]);
    
    CGContextFillEllipseInRect(content, aRect);
    
    CGContextSetStrokeColorWithColor(content, [[UIColor whiteColor] CGColor]);
    
    CGContextSetLineWidth(content, 2.0);
    
    CGContextAddEllipseInRect(content, aRect);//椭圆， 参数2:椭圆的坐标
    
    CGContextDrawPath(content, kCGPathStroke);
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    if (self.weatherList == nil || self.weatherList.count == 0) return;
        
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat perValue = (CGRectGetHeight(self.frame) - 100) / (self.maxValue - self.minValue);
    
    CGFloat width = CGRectGetWidth(self.frame) / self.weatherList.count;
    
    self.textColor = [UIColor whiteColor];
    
//    float length[] = {5, 2};
    
    for (int i = 0; i < self.weatherList.count; i++) {
        
        if (i >= self.weatherList.count) break;
            
        NSDictionary * infoDic = self.weatherList[i];
        
        NSString * dateStr = [infoDic valueForKey:@"date"];
        
        NSDate * today = [NSDate date];
        
        NSDate * yesterday = [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:today];
        
        NSDateFormatter * dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = @"yyyyMMdd000000";
        
        NSString * yesterdayStr = @"";
        
        CGFloat hight = [[infoDic valueForKey:@"highest"] floatValue];
        
        CGFloat y = (CGRectGetHeight(self.frame) - 110) - (hight - self.minValue) * perValue;
        
        CGFloat x = i * width + width / 2;
        
        //高温
        NSString * hightStr = [NSString stringWithFormat:@"%@º", [infoDic valueForKey:@"highest"]];
        
        if ([self timeZone] == 2 && i==0 ) {
            
        } else {
            [self drawText:hightStr rect:CGRectMake(i * width, y + 30, width, 20) color:self.textColor];
        }
        
        //绘制高温曲线图
        if (i + 1 < self.weatherList.count) {
            
            CGFloat nextX = (i + 1) * width + width / 2;
            
            NSDictionary * nextInfoDic = self.weatherList[i + 1];
            
            CGFloat nextHight = [[nextInfoDic valueForKey:@"highest"] floatValue];
            
            CGFloat nextY = (CGRectGetHeight(self.frame) -110) - (nextHight - self.minValue) * perValue;
            
            if ([self timeZone] == 2 && i == 0) {
                
                
            } else {
                
                if (YES) {
                    
                    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
                    
                    CGContextSetLineWidth(context, 2);
                    
                    CGContextSetLineDash(context, 0, NULL, 0);//虚线
                    
                    CGContextMoveToPoint(context, x, y + 55);
                    
                    CGContextAddLineToPoint(context, nextX, nextY + 55);
                    
                    CGContextStrokePath(context);
                    
                } else {
                    
                    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
                    
                    CGContextSetLineWidth(context, 2);
                    
                    CGContextSetLineDash(context, 0, NULL, 0);  //画虚线
                    
                    CGContextMoveToPoint(context, x, y + 55);
                    
                    CGContextAddLineToPoint(context, nextX, nextY + 55);
                    
                    CGContextStrokePath(context);
                }
            }
        }
        
        if ([self timeZone] == 2 && i == 0) {
            
            CGContextSetFillColorWithColor(context, [RGBA(181, 181, 181, 1) CGColor]);
        } else {
            [self drawPoint:context rect:CGRectMake(x - 2.5, y + 55 - 2.5, 5, 5) fillColor:RGBA(245, 108, 0, 1)];
        }
        
        CGFloat low = [[infoDic valueForKey:@"lowest"] floatValue];
        
        y = (CGRectGetHeight(self.frame) - 100) - (low - self.minValue) * perValue + 55;
        
        //绘制低温曲线
        if (i + 1 < self.weatherList.count) {
            
            CGFloat nextX = (i + 1) * width + width / 2;
            
            NSDictionary * nextInfoDic = self.weatherList[i + 1];
            
            CGFloat nextLow = [[nextInfoDic valueForKey:@"lowest"] floatValue];
            
            CGFloat nextY = (CGRectGetHeight(self.frame) -110) - (nextLow - self.minValue) * perValue + 55;
            
            if (NO && [yesterdayStr isEqualToString:dateStr]) {
                
                CGContextSetStrokeColorWithColor(context, [RGBA(181, 181, 181, 1) CGColor]);
                
                CGContextSetLineDash(context, 0, NULL, 2);//虚线
                
                CGContextMoveToPoint(context, x, y);
                
                CGContextAddLineToPoint(context, nextX, nextY);
                
                CGContextStrokePath(context);
            } else {
                
                CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
                
                CGContextSetLineWidth(context, 2);
                
                CGContextMoveToPoint(context, x, y);
                
                CGContextAddLineToPoint(context, nextX, nextY);
                
                CGContextStrokePath(context);
            }
            
            if ([yesterdayStr isEqualToString:dateStr]) {
                
                CGContextSetFillColorWithColor(context, [RGBA(181, 181, 181, 1) CGColor]);
                
                CGContextFillEllipseInRect(context, CGRectMake(x - 2.5, y - 3.5, 7, 7));
            } else {
                [self drawPoint:context rect:CGRectMake(x - 2.5, y - 2.5, 5, 5) fillColor:RGBA(24, 98, 249, 1)];
            }
            
            //低温
            NSString * lowStr = [NSString stringWithFormat:@"%@º", [infoDic valueForKey:@"lowest"]];
            
            if (NO || [yesterdayStr isEqualToString:dateStr]) {
                
                [self drawText:lowStr rect:CGRectMake(i * width, y + 5, width, 20) color:RGBA(181, 181, 181, 1)];
            } else {
                
                if ([self timeZone] == 0 || [self timeZone] == 2) {
                    
                    [self drawText:lowStr rect:CGRectMake(i * width, y + 5, width, 20) color:RGBA(16, 166, 246, 1)];
                } else {
                    
                    [self drawText:lowStr rect:CGRectMake(i * width, y + 5, width, 20) color:self.textColor];
                }
            }
            
            //星期
            float weekStartY = 8;
            
            NSString * week = [NSString stringWithFormat:@"周%@", [infoDic valueForKey:@"week"]];
            
            [self drawText:week rect:CGRectMake(i * width, weekStartY, width, 20) color:self.textColor];
            
            //日期
            NSString * dateString = [infoDic valueForKey:@"date"];
            
            NSDateFormatter * dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            
            NSDate * date = [dateFormater dateFromString:dateString];
            
            NSDateFormatter * showDateFormatter = [NSDateFormatter new];
            [showDateFormatter setDateFormat:@"M/d"];
            
            NSString * showDateString = [showDateFormatter stringFromDate:date];
            
            float dateStartY = self.frame.size.height - 28;
            
            [self drawText:showDateString rect:CGRectMake(i * width, dateStartY, width, 20) color:self.textColor];
            
            //白天天气现象
            float oneWeatherCNStartY = 30;
            NSString * oneCodeCN = [NSString stringWithFormat:@"%@", [infoDic valueForKey:@"one_code_cn"]];
            
            if ([self timeZone] == 2 && i == 0) {
                
                
            } else {
                [self drawText:oneCodeCN rect:CGRectMake(1 * width, oneWeatherCNStartY, width, 20) color:self.textColor];
            }
            
            //夜间天气现象
            float twoWeatherCNStartY = self.frame.size.height - 50;
            NSString * twoWeatherCN = [NSString stringWithFormat:@"%@", [infoDic valueForKey:@"two_code_cn"]];
            [self drawText:twoWeatherCN rect:CGRectMake(i * width, twoWeatherCNStartY, width, 20) color:self.textColor];
            
            //one 天气图片
            NSString * oneImageName = [NSString stringWithFormat:@"weathericon_day_%@.png", [infoDic valueForKey:@"one_code"]];
            
            UIImage * weatherImage = [UIImage imageNamed:oneImageName];
            
            if (NO || [yesterdayStr isEqualToString:dateStr]) {
                
                weatherImage = [weatherImage rt_tintedImageWithColor:[UIColor grayColor] level:1];
            }
            
            if ([self timeZone] == 2 && i ==0) {
                
            } else {
                [weatherImage drawInRect:CGRectMake((width - 30) / 2 + i * width, 50, 30, 30)];
            }
            
            //two天气图片
            NSString * twoImageName = [NSString stringWithFormat:@"weathericon_night_%@.png", [infoDic valueForKey:@"two_code"]];
            
            UIImage * twoWeatherImage = [UIImage imageNamed:twoImageName];
            
            if (NO || [yesterdayStr isEqualToString:dateStr]) {
                twoWeatherImage = [twoWeatherImage rt_tintedImageWithColor:[UIColor grayColor] level:1];
            } else {
                [twoWeatherImage drawInRect:CGRectMake((width - 30) / 2 + i * width, self.frame.size.height - 50 - 30, 30, 30)];
            }
        }
    }
}

#pragma mark - Getters and setters.

- (NSArray *)weatherList {
    
    if (!_weatherList) {
        
        _weatherList = [NSArray array];
    }
    return _weatherList;
}

@end
