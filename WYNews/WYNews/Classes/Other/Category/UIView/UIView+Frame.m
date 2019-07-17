//
//  UIView+Frame.m
//  Lottery
//
//  Created by monkey on 2018/9/23.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGSize)size
{
    return self.bounds.size;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.bounds;
    rect.size = size;
    self.bounds = rect;
}

- (CGFloat)width
{
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.bounds;
    rect.size.width = width;
    self.bounds = rect;
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.bounds;
    rect.size.height = height;
    self.bounds = rect;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.centerY;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

@end
