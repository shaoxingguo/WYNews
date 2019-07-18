//
//  XGCommon.h
//  工具栏优化
//
//  Created by monkey on 2019/4/16.
//  Copyright © 2019 itcast. All rights reserved.
//

@interface SXGCommon : NSObject

+ (instancetype)shared;

/// 屏幕宽度
- (CGFloat)screenWidth;
/// 屏幕高度
- (CGFloat)screenHeight;
/// 屏幕比例
- (CGFloat)screenScale;
/// 状态栏高度
- (CGFloat)statusBarHeight;
/// 导航栏高度
- (CGFloat)navigationBarHeight;
/// tabBar高度
- (CGFloat)tabBarHeight;
/// 底部间距
- (CGFloat)bottomMargin;
/// 是否是iphoneX
- (BOOL)isIphoneX;
/// 是否可用ios11
- (BOOL)isIOS11;

/// 服务器地址
- (NSString *)baseURLString;

@end





