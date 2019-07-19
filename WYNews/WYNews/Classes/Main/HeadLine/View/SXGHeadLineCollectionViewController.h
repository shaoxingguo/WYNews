//
//  SXGHeadLineCollectionViewController.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXGNewsTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface SXGHeadLineCollectionViewController : UICollectionViewController

/// 新闻话题数据模型
@property (nonatomic,strong) SXGNewsTopicModel *newsTopicModel;

/// 重置
- (void)reset;
/// 刷新数据
- (void)refresh;

@end

NS_ASSUME_NONNULL_END
