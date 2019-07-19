//
//  SXGNewsModel.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXGNewsModel : NSObject

/// 标题
@property (nonatomic,copy) NSString *title;
/// 发布时间
@property (nonatomic,copy) NSString *ptime;
/// 回帖数
@property (nonatomic,assign) NSInteger replyCount;
/// 文章id
@property (nonatomic,copy) NSString *docid;
/// 摘要
@property (nonatomic,strong) NSString *digest;
/// 图片资源
@property (nonatomic,copy) NSString *imgsrc;
/// 额外图片
@property (nonatomic,strong) NSArray<NSDictionary *> *imgextra;
/// 图片类型
@property (nonatomic,assign) NSInteger imgType;

@end

NS_ASSUME_NONNULL_END
