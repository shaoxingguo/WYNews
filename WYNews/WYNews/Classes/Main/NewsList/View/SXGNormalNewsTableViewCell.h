//
//  SXGNormalNewsTableViewCell.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXGNewsModel;

NS_ASSUME_NONNULL_BEGIN

@interface SXGNormalNewsTableViewCell : UITableViewCell

/// 新闻数据模型
@property (nonatomic,strong) SXGNewsModel *newsModel;

@end

NS_ASSUME_NONNULL_END
