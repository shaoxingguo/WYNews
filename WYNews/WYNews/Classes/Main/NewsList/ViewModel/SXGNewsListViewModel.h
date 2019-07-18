//
//  SXGNewsListViewModel.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SXGNewsViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface SXGNewsListViewModel : NSObject

/**
 加载新闻数据
 
 @param tid 新闻类型
 @param completion 完成回调
 */
- (void)loadNewsListWithTid:(NSString *)tid completion:(void(^)(BOOL isSuccess))completion;

- (NSArray<SXGNewsViewModel *> *)newsList;

@end

NS_ASSUME_NONNULL_END
