//
//  SXGHomeViewController.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/17.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "SXGHomeViewController.h"

#import "SXGNewsTopicModel.h"

@interface SXGHomeViewController ()
{
    /// 新闻话题模型数组
    NSArray<SXGNewsTopicModel *> *_newsTopicArr;
    
    /// 话题滚动视图
    UIScrollView *_newsTopicScrollView;
    /// 选中的标题按钮
    UIButton *_selectedNewsTopiccButton;
}

@end

@implementation SXGHomeViewController

#pragma mark - 控制器生命周期方法

- (void)loadView
{
    [super loadView];
    
    [self setUpUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   self.navigationItem.title = @"网易新闻";
}

#pragma mark - 事件监听

- (void)newsTopicButtonAction:(UIButton *)button
{
    button.selected = YES;;
    _selectedNewsTopiccButton.selected = NO;
    _selectedNewsTopiccButton = button;
    
    CGFloat offset = (button.centerX - [SXGCommon shared].screenWidth / 2);
    offset = fmax(offset, 0);
    [_newsTopicScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark - 内部其他私有方法

- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareTopicScrollView];
}

- (void)prepareTopicScrollView
{
    _newsTopicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [SXGCommon shared].navigationBarHeight, [SXGCommon shared].screenWidth, 44)];
    _newsTopicScrollView.backgroundColor = [UIColor orangeColor];
    _newsTopicScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _newsTopicScrollView.showsHorizontalScrollIndicator = NO;
    _newsTopicScrollView.bounces = NO;
    [self.view addSubview:_newsTopicScrollView];
    
    CGFloat width = ceil(self.view.width / 6);  // 按钮宽度 一页显示6个按钮
    [self.newsTopicArr enumerateObjectsUsingBlock:^(SXGNewsTopicModel * _Nonnull newsTopicModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithTitle:newsTopicModel.tname fontSize:15 titleColor:[UIColor darkGrayColor] target:self action:@selector(newsTopicButtonAction:)];
        button.tag = idx;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.backgroundColor = [UIColor whiteColor];
        [self->_newsTopicScrollView addSubview:button];
        button.frame = CGRectMake(width * idx, 0, width, self->_newsTopicScrollView.height);
        if (idx == 0) {
            [self newsTopicButtonAction:button];
        }
    }];
    
    _newsTopicScrollView.contentSize = CGSizeMake(width * _newsTopicArr.count, 0);
}


#pragma mark - 懒加载

- (NSArray<SXGNewsTopicModel *> *)newsTopicArr
{
    if (!_newsTopicArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        _newsTopicArr = [SXGNewsTopicModel mj_objectArrayWithKeyValuesArray:dict[@"tList"]];
    }
    
    return _newsTopicArr;
}

@end
