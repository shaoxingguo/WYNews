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

+ (void)loadHeadLineList:(void(^)(id __nullable responseObject))completion
{
    [SXGNetworkTools GetRequest:[[SXGCommon shared] headLineAPIString] parameters:nil completionHandle:^(id  _Nullable responseObject, NSError * _Nullable error) {
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
    NSString *apiString = @"https://c.m.163.com/nc/article/headline/tid/0-20.html";
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

@end
