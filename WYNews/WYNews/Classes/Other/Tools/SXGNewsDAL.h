//
//  SXGNewsDAL.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXGNewsDAL : NSObject

/// 单例
+ (instancetype)shared;

/**
 加载头条数据
 
 @param tid 新闻类型
 @param completion 完成回调
 */
- (void)loadHeadLineListWithTid:(NSString *)tid completion:(void(^)(id __nullable responseObject))completion;


/**
 加载新闻数据

 @param tid 新闻类型
 @param completion 完成回调
 */
- (void)loadNewsListWithTid:(NSString *)tid completion:(void(^)(id __nullable responseObject))completion;

/**
 加载新闻详情

 @param docid 新闻文章id
 @param completion 完成回调
 */
- (void)loadNewsDetailWithDocid:(NSString *)docid completion:(void(^)(id __nullable responseObject))completion;

@end

NS_ASSUME_NONNULL_END
