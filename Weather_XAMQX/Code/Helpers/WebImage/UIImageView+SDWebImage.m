//
//  UIImageView+SDWebImage.m
//  二次封装SDWebImage
//
//  Created by Jack on 2018/5/10.
//  Copyright © 2018 Jack. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SDWebImage)

/**
 异步加载图片
 
 @param url         图片地址
 @param imageName   占位图片名称
 */
- (void)downloadImage:(NSString *)url placeholder:(NSString * )imageName {
    
    if (!imageName) {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageLowPriority|SDWebImageRetryFailed];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:url]];
    }  
}

/**
 异步加载图片，监控进度、状态
 
 @param url         图片地址
 @param imageName   占位图片名称
 @param success     下载成功状态
 @param failed      下载失败状态
 @param progress    下载进度
 */
- (void)downloadImage:(NSString *)url
          placeholder:(NSString * )imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed
             progress:(DownloadImageProgressBlock)progress {
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        progress(receivedSize * 1.0 / expectedSize);
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            failed(error);
        } else {
            success(image);
        }
    }];
}

@end
