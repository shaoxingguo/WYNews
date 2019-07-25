//
//  AppDelegate.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/17.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <WebKit/WebKit.h>
#import <YYWebImage/YYWebImage.h>

#import "AppDelegate.h"

#import "SXGHomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[SXGHomeViewController alloc] init]];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    
    // 初始化设置
    [self initializeSetting];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}


// app进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 清除webView缓存
    NSSet *types = [WKWebsiteDataStore allWebsiteDataTypes];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{
        DEBUG_Log(@"清除完成");
    }];
    
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application
{
}

// app收到内存警告
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

#pragma mark - 其他私有方法

- (void)initializeSetting
{
    // 设置导航栏
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    navBar.tintColor = [UIColor whiteColor];
    navBar.translucent = YES;
    navBar.titleTextAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:24],
                                   NSForegroundColorAttributeName: [UIColor whiteColor]
                                   };
    
    // 设置SVProgressHUD
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor redColor]];
    
    // 设置网络指示器
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // 设置YYWebImage缓存限制
    [YYWebImageManager sharedManager].cache.diskCache.countLimit = 200; // 缓存总数
    [YYWebImageManager sharedManager].cache.diskCache.costLimit = 1024 * 1024 * 200; // 缓存大小
    [YYWebImageManager sharedManager].cache.diskCache.ageLimit = 60 * 60 * 24 * 3;  // 缓存时长
    [YYWebImageManager sharedManager].cache.diskCache.autoTrimInterval = 60 * 3; // 每隔3分钟检查一次磁盘缓存 如果超出限制 进行删除
    
    [YYWebImageManager sharedManager].cache.memoryCache.countLimit = 50; // 缓存总数
    [YYWebImageManager sharedManager].cache.memoryCache.costLimit = 1024 * 1024 * 50; // 缓存大小
    [YYWebImageManager sharedManager].cache.memoryCache.autoTrimInterval = 60;  // 每隔60秒检查一次内存 如果超出限制 进行删除
}

@end
