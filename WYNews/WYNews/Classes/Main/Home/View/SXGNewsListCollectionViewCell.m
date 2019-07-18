//
//  SXGNewsListCollectionViewCell.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import "SXGNewsListCollectionViewCell.h"

#import "SXGNewsListTableViewController.h"

@implementation SXGNewsListCollectionViewCell
{
    SXGNewsListTableViewController *_newsListTableViewController;
}
#pragma mark - 构造方法

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    
    return self;
}

- (void)setUpUI
{
    _newsListTableViewController = [[SXGNewsListTableViewController alloc] init];
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_newsListTableViewController.view];
    
    _newsListTableViewController.view.frame = self.contentView.bounds;
    _newsListTableViewController.tableView.tableHeaderView.height = 180;
}

- (void)setNewsTopicModel:(SXGNewsTopicModel *)newsTopicModel
{
    _newsListTableViewController.newsTopicModel = newsTopicModel;
}

@end
