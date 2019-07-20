//
//  SXGNewsListTableViewController.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <MJRefresh/MJRefresh.h>

#import "SXGNewsListTableViewController.h"
#import "SXGHeadLineCollectionViewController.h"
#import "SXGNewsDetailViewController.h"

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

#pragma mark - 控制器生命周期方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpTableView];
    
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)dealloc
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

#pragma mark - 事件监听

- (void)refreshNewsListData
{
    [self loadNewsListData];
    [_headLineViewController refresh];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SXGNewsDetailViewController *viewController = [[SXGNewsDetailViewController alloc] initWithNewsViewModel:_newsListViewModel.newsList[indexPath.row]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.title = @"新闻详情";
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
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
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollsToTop = YES;
    
    [self prepareHeadLineView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNewsListData)];
}

- (void)prepareHeadLineView
{
    _headLineViewController = [[SXGHeadLineCollectionViewController alloc] init];
    [self addChildViewController:_headLineViewController];
    [_headLineViewController didMoveToParentViewController:self];
    
    self.tableView.tableHeaderView = _headLineViewController.view;
    _headLineViewController.view.height = 240;
}

- (void)loadNewsListData
{
    // 请求新闻列表数据
    NSString *tid = _newsTopicModel != nil ? _newsTopicModel.tid : @"T1348647853363";
    [_newsListViewModel loadNewsListWithTid:tid completion:^(BOOL isSuccess) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        if (!isSuccess) {
            [SVProgressHUD showErrorWithStatus:@"加载新闻数据失败,请检查网络连接"];
            return;
        }
        
        [self.tableView reloadData];
    }];
}

- (void)setNewsTopicModel:(SXGNewsTopicModel *)newsTopicModel
{
    // 重置cell
    [self reset];
    if (_newsTopicModel != newsTopicModel) {
        _newsTopicModel = newsTopicModel;
        [SXGNetworkTools cancelAllOperations];
        [self loadNewsListData];
    }
    
    _headLineViewController.newsTopicModel = newsTopicModel;
}

- (void)reset
{
    if ([self.tableView visibleCells].count > 1) {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }
}

@end
