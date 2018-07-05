//
//  UIImageView+SDWebImage.h
//  二次封装SDWebImage
//
//  Created by Jack on 2018/5/10.
//  Copyright © 2018 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownloadImageSuccessBlock)(UIImage * image);
typedef void(^DownloadImageFailedBlock)(NSError * error);
typedef void(^DownloadImageProgressBlock)(CGFloat progress);

@interface UIImageView (SDWebImage)


/**
 异步加载图片

 @param url         图片地址
 @param imageName   无网络时显示的图片名称
 */
- (void)downloadImage:(NSString *)url placeholder:(NSString * )imageName;



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
             progress:(DownloadImageProgressBlock)progress;


@end
