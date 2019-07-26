//
//  SXGNewsDetailViewController.h
//  WYNews
//
//  Created by shaoxingguo on 2019/7/19.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXGNewsViewModel;

@protocol SXGNewsDetailViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface SXGNewsDetailViewController : UIViewController

/// 代理
@property (nonatomic,weak) id<SXGNewsDetailViewControllerDelegate> delegate;

- (instancetype)initWithNewsViewModel:(SXGNewsViewModel *)newsViewModel;

@end

@protocol SXGNewsDetailViewControllerDelegate <NSObject>

@optional
- (void)newsDetailViewControllerDidClose:(SXGNewsDetailViewController *)newsDetailViewController;

@end

NS_ASSUME_NONNULL_END
