//
//  XGNetworkTools.m
//  封装
//
//  Created by monkey on 2017/8/4.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "XGNetworkTools.h"

static NSString *const API_BaseURL = @"https://c.m.163.com/nc/";

@implementation XGNetworkTools

#pragma mark - 单例

+ (instancetype)sharedTools
{
    static XGNetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 15;
        config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_BaseURL] sessionConfiguration:config];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",nil];
    });
    
    return instance;
}

#pragma mark - 请求方法

+ (void)GetRequest:(NSString *)urlString parameters:(NSDictionary *)parameters completionHandle:(HttpCompletionHandleBlock)completionHandle
{
    [[XGNetworkTools sharedTools] GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil,error);
    }];
}

+ (void)PostRequest:(NSString *)urlString parameters:(NSDictionary *)parameters completionHandle:(HttpCompletionHandleBlock)completionHandle
{
    [[XGNetworkTools sharedTools] POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandle(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil,error);
    }];
}

#pragma mark - 上传文件

+ (void)UploadFile:(NSString *)urlString parameters:parameters fileData:(NSData *)fileData fieldName:(NSString *)fieldName completionHandle:(HttpCompletionHandleBlock)completionHandle
{
    [[XGNetworkTools sharedTools] POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:fieldName fileName:@"xxx.png" mimeType:@"application/octet-stream"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         completionHandle(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandle(nil,error);
    }];
}

#pragma mark - 下载文件

+ (void)downLoadFile:(NSString *)urlString progressHandle:(HttpDownloadProgressHandleBlock)progressHandle completionHandle:(HttpDownloadCompletionHandleBlock)completionHandle
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [[[XGNetworkTools sharedTools] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progressHandle(downloadProgress.fractionCompleted);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // targetPath是默认的文件存储路径 下载完会自动删除 所以要自己指定保存的路径 即这里的返回值
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        completionHandle(filePath.path,error);
    }] resume];
}
@end
