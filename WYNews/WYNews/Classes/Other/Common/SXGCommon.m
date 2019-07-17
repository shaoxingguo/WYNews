//
//  XGCommon.m
//  工具栏优化
//
//  Created by monkey on 2019/4/16.
//  Copyright © 2019 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@implementation SXGCommon
{
    CGFloat _screenWidth;
    CGFloat _screenHeight;
    CGFloat _screenScale;
    CGFloat _statusBarHeight;
    CGFloat _navigationBarHeight;
    CGFloat _tabBarHeight;
    CGFloat _bottomMargin;
    BOOL _isIphoneX;
    BOOL _isIOS11;
}

#pragma mark - 单例方法

+ (instancetype)shared
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 应用程序相关常量
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
        _screenScale = [UIScreen mainScreen].scale;
        
        _statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        _navigationBarHeight = 44 + _statusBarHeight;

        _isIphoneX = _statusBarHeight > 20;
        _bottomMargin = _isIphoneX ? 34 : 0;
        _tabBarHeight = 49 + _bottomMargin;
        _isIOS11 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 11, .minorVersion = 0, .patchVersion = 0}];
    }
    
    return self;
}

#pragma mark - 开放方法

- (CGFloat)screenWidth
{
    return _screenWidth;
}

- (CGFloat)screenHeight
{
    return _screenHeight;
}

- (CGFloat)screenScale
{
    return _screenScale;
}

- (CGFloat)statusBarHeight
{
    return _statusBarHeight;
}

- (CGFloat)navigationBarHeight
{
    return _navigationBarHeight;
}

- (CGFloat)tabBarHeight
{
    return _tabBarHeight;
}

- (CGFloat)bottomMargin
{
    return _bottomMargin;
}

- (BOOL)isIphoneX
{
    return _isIphoneX;
}

- (BOOL)isIOS11
{
    return _isIOS11;
}

@end
