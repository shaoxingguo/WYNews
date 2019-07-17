//
//  UINavigationController+XG.m
//  demo
//
//  Created by monkey on 2019/6/23.
//  Copyright © 2019 itcast. All rights reserved.
//

#import <objc/runtime.h>

#import "UINavigationController+XG.h"

@interface XGPanGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation XGPanGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // 只有根控制器时禁用
    if (_navigationController.childViewControllers.count == 1) {
        return NO;
    } else if ([gestureRecognizer translationInView:gestureRecognizer.view].x <= 0) {
        // 右滑时禁用
        return NO;
    } else {
        return YES;
    }
}

@end

@implementation UINavigationController (XG)

+ (void)load
{
    // 交换方法
    Method push = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method xgPush = class_getInstanceMethod(self, @selector(xg_pushViewController:animated:));
    method_exchangeImplementations(push, xgPush);
}

#pragma mark - 私有push方法

- (void)xg_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 如果手势列表中没有滑动手势 进行添加
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:[self panGestureRecognizer]]) {
        UIPanGestureRecognizer *pan = [self panGestureRecognizer];
        // 设置手势事件方法
        id targets = [[self.interactivePopGestureRecognizer valueForKey:@"targets"] lastObject];
        id target = [targets valueForKey:@"target"];
        [pan addTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
        pan.delegate = [self panGestureRecognizerDelegate];
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:pan];
        
        // 禁用系统手势
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.viewControllers.count > 0) {
        [viewController setHidesBottomBarWhenPushed:YES];
        // 如果不设置背景色 退拽手势的时候 右上角有黑色
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self xg_pushViewController:viewController animated:animated];
}

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, "_panGestureRecognizer");
    if (pan == nil) {
        pan = [[UIPanGestureRecognizer alloc] init];
        objc_setAssociatedObject(self, "_panGestureRecognizer", pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return pan;
}

- (XGPanGestureRecognizerDelegate *)panGestureRecognizerDelegate
{
    XGPanGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, "_panGestureRecognizerDelegate");
    if (delegate == nil) {
        delegate = [[XGPanGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        objc_setAssociatedObject(self, "_panGestureRecognizerDelegate", delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return delegate;
}

@end
