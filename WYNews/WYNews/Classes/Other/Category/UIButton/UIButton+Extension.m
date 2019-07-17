//
//  UIButton+Extension.m
//  Lottery
//
//  Created by monkey on 2018/9/23.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

#pragma mark - 按钮布局

- (void)layoutButtonWithEdgeInsetsStyle:(KButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
    /**
     *  知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    
    switch (style) {
        case KButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case KButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case KButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case KButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

#pragma mark - 快速创建对象方法

- (instancetype)initWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action
{
    if (self = [self initWithTitle:nil fontSize:15 titleColor:nil imageName:imageName highlightedImageName:highlightedImageName backgroundImageName:nil highlightedBackgroundImageName:nil target:target action:action]) {
    }
    
    return self;
}

+ (instancetype)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action
{
    return [[self alloc] initWithImageName:imageName highlightedImageName:highlightedImageName target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{

    if (self = [self initWithTitle:title fontSize:fontSize titleColor:titleColor imageName:nil highlightedImageName:nil backgroundImageName:nil highlightedBackgroundImageName:nil target:target action:action]) {
    }
    
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title fontSize:fontSize titleColor:titleColor target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action
{
   
    if (self = [self initWithTitle:title fontSize:fontSize titleColor:titleColor imageName:imageName highlightedImageName:highlightedImageName backgroundImageName:nil highlightedBackgroundImageName:nil target:target action:action]) {
    }
    
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title fontSize:fontSize titleColor:titleColor imageName:imageName highlightedImageName:highlightedImageName target:target action:action];
}

- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor backgroundImageName:(NSString *)backgroundImageName highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName target:(id)target action:(SEL)action
{
  
    if (self = [self initWithTitle:title fontSize:fontSize titleColor:titleColor imageName:nil highlightedImageName:nil backgroundImageName:backgroundImageName highlightedBackgroundImageName:highlightedBackgroundImageName target:target action:action]) {
    }
    
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor backgroundImageName:(NSString *)backgroundImageName highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName target:(id)target action:(SEL)action
{
    return [[self alloc] initWithTitle:title fontSize:fontSize titleColor:titleColor backgroundImageName:backgroundImageName highlightedBackgroundImageName:highlightedBackgroundImageName target:target action:action];
}

+ (instancetype)buttonWithTitle:(NSString *_Nullable)title fontSize:(CGFloat)fontSize titleColor:(UIColor *_Nullable)titleColor imageName:(NSString *_Nullable)imageName highlightedImageName:(NSString *_Nullable)highlightedImageName backgroundImageName:(NSString *_Nullable)backgroundImageName highlightedBackgroundImageName:(NSString *_Nullable)highlightedBackgroundImageName target:(id _Nullable)target action:(SEL _Nullable)action
{
    return [[self alloc] initWithTitle:title fontSize:fontSize titleColor:titleColor imageName:imageName highlightedImageName:highlightedImageName backgroundImageName:backgroundImageName highlightedBackgroundImageName:highlightedBackgroundImageName target:target action:action];
}

- (instancetype)initWithTitle:(NSString *_Nullable)title fontSize:(CGFloat)fontSize titleColor:(UIColor *_Nullable)titleColor imageName:(NSString *_Nullable)imageName highlightedImageName:(NSString *_Nullable)highlightedImageName backgroundImageName:(NSString *_Nullable)backgroundImageName highlightedBackgroundImageName:(NSString *_Nullable)highlightedBackgroundImageName target:(id _Nullable)target action:(SEL _Nullable)action
{
    if (self = [super init]) {
        if (title != nil) {
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitleColor:titleColor forState:UIControlStateNormal];
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
        
        if (imageName != nil && highlightedImageName != nil) {
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
        }
        
        if (backgroundImageName != nil && highlightedBackgroundImageName != nil) {
            [self setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:highlightedBackgroundImageName] forState:UIControlStateHighlighted];
        }
        
        if (target != nil && action != nil) {
            [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self sizeToFit];
    }
    
    return self;
}

@end
