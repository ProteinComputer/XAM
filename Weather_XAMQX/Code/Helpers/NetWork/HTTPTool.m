//
//  HTTPTool.m
//  二次封装AFN
//
//  Created by Jack on 2018/5/10.
//  Copyright © 2018 Jack. All rights reserved.
//

#import "HTTPTool.h"

static NSString * kBaseURL = @"http://218.202.74.146:10132/product_weather";
//static NSString * kBaseURL = @"http://192.168.1.103";


@interface AFHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedHTTPClient;

@end

@implementation AFHTTPClient

/**
 自定义会话管理类

 @return 返回单例对象
 */
+ (instancetype)sharedHTTPClient {
    
    static AFHTTPClient * client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"text/plain", @"image/gif", nil];
        
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    return client;
}

@end

@implementation HTTPTool

/**
 GET异步网络请求
 
 @param path    请求地址
 @param params  请求参数
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)getWitPath:(NSString *)path
            params:(NSDictionary *)params
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure {
    
    NSString * url = [kBaseURL stringByAppendingPathComponent:path];
    
    [[AFHTTPClient sharedHTTPClient] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


/**
 POST异步网络请求
 
 @param path    请求地址
 @param params  请求参数
 @param success 请求成功
 @param failure 请求失败
 */
+ (void)postWitPath:(NSString *)path
            params:(NSDictionary *)params
           success:(HttpSuccessBlock)success
           failure:(HttpFailureBlock)failure {
    
    NSString * url = [kBaseURL stringByAppendingPathComponent:path];
    
    [[AFHTTPClient sharedHTTPClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

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
                 failure:(HttpFailureBlock)failure {
    
    NSString * urlString = [kBaseURL stringByAppendingPathComponent:path];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    
    [[[AFHTTPClient sharedHTTPClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //        NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSURL * documentDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentDirectoryURL URLByAppendingPathComponent:response.suggestedFilename];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
    }] resume];
    
}

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
               failure:(HttpFailureBlock)failure {
    
    NSString * urlString = [kBaseURL stringByAppendingPathComponent:path];
    
    [[AFHTTPClient sharedHTTPClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * data = UIImagePNGRepresentation(image);
        
        [formData appendPartWithFileData:data name:imageKey fileName:saveName  mimeType:saveType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end















