//
//  SXGNewsListViewModel.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "SXGNewsListViewModel.h"

#import "SXGNewsDAL.h"

#import "SXGNewsModel.h"
#import "SXGNewsViewModel.h"

@implementation SXGNewsListViewModel
{
    /// 新闻视图模型
    NSMutableArray<SXGNewsViewModel *> *_newsViewModelArrM;
}

#pragma mark - 构造方法

- (instancetype)init
{
    if (self = [super init]) {
        _newsViewModelArrM = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - 开放方法

- (void)loadNewsListWithTid:(NSString *)tid completion:(void (^)(BOOL))completion
{
    [[SXGNewsDAL shared] loadNewsListWithTid:tid completion:^(id  _Nullable responseObject) {
        if (responseObject == nil || [responseObject count] == 0) {
            completion(NO);
            return;
        }
        
        NSArray<SXGNewsModel *> *newsModelArr = [SXGNewsModel mj_objectArrayWithKeyValuesArray:responseObject];
        NSArray<SXGNewsViewModel *>*newsViewModelArr = [SXGNewsViewModel viewModelArrayWithNewsModelArray:newsModelArr];
        [self->_newsViewModelArrM removeAllObjects];
        [self->_newsViewModelArrM addObjectsFromArray:newsViewModelArr];
        completion(YES);
    }];
}

- (NSArray<SXGNewsViewModel *> *)newsList
{
    return _newsViewModelArrM;
}

@end
