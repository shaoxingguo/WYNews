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

#import "SXGNoNetworkTableViewCell.h"
#import "SXGNormalNewsTableViewCell.h"

#import "SXGNewsListViewModel.h"

static NSString *kSXGNoNetworkTableViewCellReuseIdentifier = @"SXGNoNetworkTableViewCell";
static NSString *kSXGNormalNewsTableViewCellReuseIdentifier = @"SXGNormalNewsTableViewCell";

@interface SXGNewsListTableViewController ()
{
    /// 新闻列表视图模型
    SXGNewsListViewModel *_newsListViewModel;
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
    [self loadNewsListData];
    
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
    
    SXGNormalNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSXGNormalNewsTableViewCellReuseIdentifier];
    cell.newsViewModel = _newsListViewModel.newsList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    
    return 100;
}

#pragma mark - 其他私有方法

- (void)setUpTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[SXGNoNetworkTableViewCell class] forCellReuseIdentifier:kSXGNoNetworkTableViewCellReuseIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SXGNormalNewsTableViewCell class]) bundle:nil] forCellReuseIdentifier:kSXGNormalNewsTableViewCellReuseIdentifier];
    
    self.tableView.estimatedRowHeight = 100;
}

- (void)loadNewsListData
{
    [_newsListViewModel loadNewsListWithTid:@"T1348647853363" completion:^(BOOL isSuccess) {
        if (!isSuccess) {
            [SVProgressHUD showErrorWithStatus:@"加载新闻数据失败,请检查网络连接"];
            return;
        }
        
        [self.tableView reloadData];
    }];
}

@end
