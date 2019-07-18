//
//  SXGNewsListTableViewController.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>

#import "SXGNewsListTableViewController.h"

#import "SXGNoNetworkTableViewCell.h"
#import "SXGNormalNewsTableViewCell.h"

#import "SXGNewsDAL.h"

#import "SXGNewsModel.h"

static NSString *kSXGNoNetworkTableViewCellReuseIdentifier = @"SXGNoNetworkTableViewCell";
static NSString *kSXGNormalNewsTableViewCellReuseIdentifier = @"SXGNormalNewsTableViewCell";

@interface SXGNewsListTableViewController ()
{
    /// 新闻数据模型数组
    NSMutableArray<SXGNewsModel *> *_newsListArrM;
}

@end

@implementation SXGNewsListTableViewController

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
    
    return [self newsListArrM].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:kSXGNoNetworkTableViewCellReuseIdentifier];
    }
    
    SXGNormalNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSXGNormalNewsTableViewCellReuseIdentifier];
    cell.newsModel = _newsListArrM[indexPath.item];
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
    [SXGNewsDAL loadNewsListWithTid:@"T1348647853363" completion:^(id  _Nullable responseObject) {
        if (responseObject == nil || [responseObject count] == 0) {
            [SVProgressHUD showErrorWithStatus:@"加载新闻数据失败,请检查网络连接"];
            return;
        }
        
        [self->_newsListArrM addObjectsFromArray:[SXGNewsModel mj_objectArrayWithKeyValuesArray:responseObject]];
        [self.tableView reloadData];
    }];
}

#pragma mark - 懒加载

- (NSMutableArray<SXGNewsModel *> *)newsListArrM
{
    if (!_newsListArrM) {
        _newsListArrM = [NSMutableArray array];
    }
    
    return _newsListArrM;
}

@end
