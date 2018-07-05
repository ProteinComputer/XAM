//
//  HTTPTool.h
//  二次封装AFN
//
//  Created by Jack on 2018/5/10.
//  Copyright © 2018 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^HttpSuccessBlock)(id json);
typedef void(^HttpFailureBlock)(NSError * error);
typedef void(^HttpDownloadProgress)(CGFloat progress);
typedef void(^HttpUploadProgress)(CGFloat progress);

@interface HTTPTool : NSObject


/**
 Get 异步网络请求

 @param path        请求地址
 @param params      请求参数
 @param success     请求成功
 @param failure     请求失败
 */
+ (void)getWitPath:(NSString *)path
            params:(NSDictionary *)params
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure;

/**
 POST 异步网络请求
 
 @param path        请求地址
 @param params      请求参数
 @param success     请求成功
 @param failure     请求失败
 */
+ (void)postWitPath:(NSString *)path
            params:(NSDictionary *)params
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure;



/**
 异步网络下载

 @param path        资源地址
 @param progress    下载进度
 @param success     下载成功
 @param failure     下载失败
 */
+ (void)downloadWithPath:(NSString *)path
                progress:(HttpDownloadProgress)progress
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure;


/**
 异步网络上传

 @param path        上传地址
 @param params      上传参数
 @param image       将要上传的图片
 @param imageKey    服务器提供的图片key值
 @param saveName    图片保存名称
 @param saveType    图片保存类型
 @param progress    上传进度
 @param success     上传成功
 @param failure     上传失败
 */
+ (void)uploadWithPath:(NSString *)path
                params:(NSDictionary *)params
                 image:(UIImage *)image
              imageKey:(NSString *)imageKey
              saveName:(NSString *)saveName
              saveType:(NSString *)saveType
              progress:(HttpUploadProgress)progress
               success:(HttpSuccessBlock)success
               failure:(HttpFailureBlock)failure;

@end
