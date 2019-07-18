//
//  SXGHeadLineCollectionViewCell.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXGHeadLineModel;

NS_ASSUME_NONNULL_BEGIN

@interface SXGHeadLineCollectionViewCell : UICollectionViewCell

/// 头条数据模型
@property (nonatomic,strong) SXGHeadLineModel *headLineModel;

@end

NS_ASSUME_NONNULL_END
