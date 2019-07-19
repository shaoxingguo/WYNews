//
//  SXGNewsDAL.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import "SXGNewsDAL.h"

#import "SXGNetworkTools.h"

@implementation SXGNewsDAL

+ (void)loadHeadLineListWithTid:(NSString *)tid completion:(void(^)(id __nullable responseObject))completion
{
    NSString *apiString = @"article/headline/tid/0-10.html";
    apiString = [apiString stringByReplacingOccurrencesOfString:@"/tid/" withString:[NSString stringWithFormat:@"/%@/",tid]];
    [SXGNetworkTools GetRequest:apiString parameters:nil completionHandle:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error != nil || responseObject == nil) {
            DEBUG_Log(@"加载头条数据失败%@",error.localizedDescription);
            completion(nil);
            return;
        }
        
        // 默认返回10条头条 只取5个
        NSString *key = [responseObject allKeys].firstObject;
        NSArray *arr = responseObject[key];
        if (arr.count > 5) {
            arr = [arr subarrayWithRange:NSMakeRange(0, 5)];
        }
       
        completion(arr);
    }];
}

+ (void)loadNewsListWithTid:(NSString *)tid completion:(void(^)(id __nullable responseObject))completion
{
    NSString *apiString = @"article/headline/tid/0-20.html";
    apiString = [apiString stringByReplacingOccurrencesOfString:@"/tid/" withString:[NSString stringWithFormat:@"/%@/",tid]];
    [SXGNetworkTools GetRequest:apiString parameters:nil completionHandle:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error != nil || responseObject == nil) {
            DEBUG_Log(@"加载新闻数据失败%@",error.localizedDescription);
            completion(nil);
            return;
        }
        
        NSString *key = [responseObject allKeys].firstObject;
        NSArray *arr = responseObject[key];
        completion(arr);
    }];
}

+ (void)loadNewsDetailWithDocid:(NSString *)docid completion:(void (^)(id _Nullable))completion
{
    NSString *apiString = @"article/docid/full.html";
     apiString = [apiString stringByReplacingOccurrencesOfString:@"/docid/" withString:[NSString stringWithFormat:@"/%@/",docid]];
    [SXGNetworkTools GetRequest:apiString parameters:nil completionHandle:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (error != nil || responseObject == nil) {
            DEBUG_Log(@"加载新闻详情失败%@",error.localizedDescription);
            completion(nil);
            return;
        }
        
        NSString *key = [responseObject allKeys].firstObject;
        NSDictionary *dict = responseObject[key];
        completion(dict);
    }];
}

@end
