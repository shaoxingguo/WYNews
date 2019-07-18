//
//  SXGNewsListCollectionViewCell.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXGNewsViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface SXGNewsListCollectionViewCell : UICollectionViewCell

/// 新闻数据模型
@property (nonatomic,strong) SXGNewsViewModel *newsViewModel;

@end

NS_ASSUME_NONNULL_END
