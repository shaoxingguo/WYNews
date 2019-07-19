//
//  SXGNewsListTableViewController.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

#import "SXGNewsListTableViewController.h"
#import "SXGHeadLineCollectionViewController.h"

#import "SXGNoNetworkTableViewCell.h"
#import "SXGNormalNewsTableViewCell.h"
#import "SXGExtraImageNewsTableViewCell.h"
#import "SXGBigImageNewsTableViewCell.h"

#import "SXGNewsListViewModel.h"
#import "SXGNewsTopicModel.h"

#import "SXGNewsViewModel.h"

#import "SXGNetworkTools.h"

static NSString *kSXGNoNetworkTableViewCellReuseIdentifier = @"SXGNoNetworkTableViewCell";
static NSString *kSXGNormalNewsTableViewCellReuseIdentifier = @"SXGNormalNewsTableViewCell";
static NSString *kSXGExtraImageNewsTableViewCellReuseIdentifier = @"SXGExtraImageNewsTableViewCell";
static NSString *kSXGBigImageNewsTableViewCellReuseIdentifier = @"SXGBigImageNewsTableViewCell";


@interface SXGNewsListTableViewController ()
{
    /// 新闻列表视图模型
    SXGNewsListViewModel *_newsListViewModel;
    /// 头条视图控制器
    SXGHeadLineCollectionViewController *_headLineViewController;
    /// 新闻话题数据模型
    SXGNewsTopicModel *_newsTopicModel;
}

@end

@implementation SXGNewsListTableViewController

#pragma mark - 构造方法

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        _newsListViewModel = [[SXGNewsListViewModel alloc] init];
    }
    
    return self;
}

#pragma mark - 开放方法

- (void)reset
{
    if ([self.tableView visibleCells].count > 1) {
        [_headLineViewController reset];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - 控制器生命周期方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkingReachabilityDidChangeNotification) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 事件监听

- (void)networkingReachabilityDidChangeNotification
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 数据源和代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [AFNetworkReachabilityManager sharedManager].reachable ? 0 : 1;
    }
    
    return _newsListViewModel.newsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:kSXGNoNetworkTableViewCellReuseIdentifier];
    }
    
    NSString *reuseIdentifier = nil;
    SXGNewsViewModel *newsViewModel = _newsListViewModel.newsList[indexPath.row];
    if (newsViewModel.imgextra != nil) {
        reuseIdentifier = kSXGExtraImageNewsTableViewCellReuseIdentifier;
    } else if (newsViewModel.isBigImage) {
        reuseIdentifier = kSXGBigImageNewsTableViewCellReuseIdentifier;
    } else {
        reuseIdentifier = kSXGNormalNewsTableViewCellReuseIdentifier;
    }
    
    SXGNormalNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.newsViewModel = newsViewModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    } else if (_newsListViewModel.newsList[indexPath.row].imgextra != nil) {
        return 140;
    } else if (_newsListViewModel.newsList[indexPath.row].isBigImage) {
        return 150;
    } else {
        return 100;
    }
}

#pragma mark - 其他私有方法

- (void)setUpTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[SXGNoNetworkTableViewCell class] forCellReuseIdentifier:kSXGNoNetworkTableViewCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SXGNormalNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSXGNormalNewsTableViewCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SXGExtraImageNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSXGExtraImageNewsTableViewCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SXGBigImageNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSXGBigImageNewsTableViewCellReuseIdentifier];

    self.tableView.estimatedRowHeight = 150;
    
    [self prepareHeadLineView];
}

- (void)prepareHeadLineView
{
    _headLineViewController = [[SXGHeadLineCollectionViewController alloc] init];
    [self addChildViewController:_headLineViewController];
    [_headLineViewController didMoveToParentViewController:self];
    
    self.tableView.tableHeaderView = _headLineViewController.view;
    _headLineViewController.view.height = 180;
}

- (void)loadNewsListData
{
    NSString *tid = _newsTopicModel != nil ? _newsTopicModel.tid : @"T1348647853363";
    [_newsListViewModel loadNewsListWithTid:tid completion:^(BOOL isSuccess) {
        if (!isSuccess) {
            [SVProgressHUD showErrorWithStatus:@"加载新闻数据失败,请检查网络连接"];
            return;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)setNewsTopicModel:(SXGNewsTopicModel *)newsTopicModel
{
    if (_newsTopicModel != newsTopicModel) {
        [SXGNetworkTools cancelAllOperations];
        _newsTopicModel = newsTopicModel;
        _headLineViewController.newsTopicModel = newsTopicModel;
        [self loadNewsListData];
    }
}

@end
