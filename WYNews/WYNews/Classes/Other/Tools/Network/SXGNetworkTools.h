//
//  XGNetworkTools.h
//  封装
//
//  Created by monkey on 2017/8/4.
//  Copyright © 2017年 itcast. All rights reserved.
//
  
#import <AFNetworking/AFNetworking.h>

@interface SXGNetworkTools : AFHTTPSessionManager

typedef void (^HttpCompletionHandleBlock)(id _Nullable responseObject,NSError * _Nullable error);
typedef void (^HttpDownloadProgressHandleBlock)(CGFloat progress);
typedef void (^HttpDownloadCompletionHandleBlock)(NSString * _Nullable filePath,NSError * _Nullable error);

/**
 Get请求

 @param urlString 请求地址
 @param parameters 请求参数
 @param completionHandle 完成回调
 */
+ (void)GetRequest:(NSString * _Nonnull)urlString parameters:(NSDictionary * _Nullable)parameters completionHandle:(HttpCompletionHandleBlock _Nonnull)completionHandle;


/**
 Post请求

 @param urlString 请求地址
 @param parameters 请求参数
 @param completionHandle 完成回调
 */
+ (void)PostRequest:(NSString * _Nonnull)urlString parameters:(NSDictionary * _Nullable)parameters completionHandle:(HttpCompletionHandleBlock _Nonnull)completionHandle;


/**
 上传文件

 @param urlString 请求地址
 @param fileData 文件
 @param fieldName 字段名称
 @param completionHandle 完成回调
 */
+ (void)UploadFile:(NSString * _Nonnull)urlString parameters:parameters fileData:(NSData * _Nonnull)fileData fieldName:(NSString * _Nonnull)fieldName completionHandle:(HttpCompletionHandleBlock _Nonnull)completionHandle;


/**
 下载文件

 @param urlString 资源地址
 @param progressHandle 进度回调
 @param completionHandle 完成回调
 */
+ (void)downLoadFile:(NSString * _Nonnull)urlString progressHandle:(HttpDownloadProgressHandleBlock _Nonnull)progressHandle completionHandle:(HttpDownloadCompletionHandleBlock _Nonnull)completionHandle;

/// 取消所有正在进行的网络请求
+ (void)cancelAllOperations;

@end
