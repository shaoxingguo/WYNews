//
//  SXGNewsDetailViewController.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/19.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "SXGNewsDetailViewController.h"

#import "SXGNewsViewModel.h"

#import "SXGNewsDAL.h"

@implementation SXGNewsDetailViewController
{
    /// 网页
    WKWebView *_webView;
    /// 新闻数据模型
    SXGNewsViewModel *_newsViewModel;
    /// 新闻详情字典
    NSDictionary *_newsDetailDictionary;
}

#pragma mark - 构造方法

- (instancetype)initWithNewsViewModel:(SXGNewsViewModel *)newsViewModel
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _newsViewModel = newsViewModel;
    }
    
    return self;
}

#pragma mark - 控制器生命周期方法

- (void)loadView
{
    [self setUpUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadNewsDetailData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
}

#pragma mark - 事件监听

- (void)goBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 内部其他私有方法

- (void)setUpUI
{
    _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    self.view = _webView;
}

- (void)loadNewsDetailData
{
    [[SXGNewsDAL shared] loadNewsDetailWithDocid:_newsViewModel.docid completion:^(id  _Nullable responseObject) {
        if (responseObject == nil) {
            [SVProgressHUD showErrorWithStatus:@"加载新闻详情失败!"];
            return;
        }
        
        self->_newsDetailDictionary = responseObject;
        [self loadHtml];
    }];
}

- (void)loadHtml
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"newsDetail.html" ofType:nil];
    NSMutableString *htmlString = [NSMutableString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [htmlString replaceOccurrencesOfString:@"@title" withString:_newsDetailDictionary[@"title"] options:0 range:NSMakeRange(0, htmlString.length)];
    [htmlString replaceOccurrencesOfString:@"@time" withString:_newsDetailDictionary[@"ptime"] options:0 range:NSMakeRange(0, htmlString.length)];
    [htmlString replaceOccurrencesOfString:@"@body" withString:_newsDetailDictionary[@"body"] options:0 range:NSMakeRange(0, htmlString.length)];
    
    for (NSDictionary *dict in _newsDetailDictionary[@"img"]) {
        NSString *ref = dict[@"ref"];
        NSString *src = dict[@"src"];
        NSString *img = [NSString stringWithFormat:@"<img src='%@' width='80%%'>",src];
        [htmlString replaceOccurrencesOfString:ref withString:img options:0 range:NSMakeRange(0, htmlString.length)];
    }
    
    [_webView loadHTMLString:htmlString baseURL:nil];
}

@end
