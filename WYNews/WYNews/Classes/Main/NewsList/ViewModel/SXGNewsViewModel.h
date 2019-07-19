//
//  SXGNewsViewModel.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SXGNewsModel;

NS_ASSUME_NONNULL_BEGIN

@interface SXGNewsViewModel : NSObject

- (instancetype)initWithNewsModel:(SXGNewsModel *)newsModel;
+ (instancetype)viewModelWithNewsModel:(SXGNewsModel *)newsModel;

+ (NSArray<SXGNewsViewModel *> *)viewModelArrayWithNewsModelArray:(NSArray<SXGNewsModel *> *)newsModelArr;

/// 标题
- (NSString *)title;
/// 发布时间
- (NSString *)postime;
/// 回帖数
- (NSString *)replyCount;
/// 文章id
- (NSString *)docid;
/// 摘要
- (NSString *)digest;
/// 图片资源
- (NSString *)imgsrc;
/// 额外图片
- (NSArray<NSString *> *__nullable)imgextra;
/// 是否是大图
- (BOOL)isBigImage;

@end

NS_ASSUME_NONNULL_END
