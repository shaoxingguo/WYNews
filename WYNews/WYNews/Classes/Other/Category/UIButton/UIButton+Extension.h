//
//  UIButton+Extension.h
//  Lottery
//
//  Created by monkey on 2018/9/23.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, KButtonEdgeInsetsStyle) {
    KButtonEdgeInsetsStyleTop, // image在上，label在下
    KButtonEdgeInsetsStyleLeft, // image在左，label在右
    KButtonEdgeInsetsStyleBottom, // image在下，label在上
    KButtonEdgeInsetsStyleRight // image在右，label在左
};

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(KButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;


/**
 快速创建对象方法

 @param imageName 图片名
 @param highlightedImageName 高亮状态图片名
 @param target 监听者
 @param action 监听方法
 @return UIButton
 */
+ (instancetype)buttonWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;
- (instancetype)initWithImageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

/**
 快速创建对象方法
 
 @param title 标题
 @param fontSize 字体大小
 @param titleColor 字体颜色
 @param target 监听者
 @param action 监听方法
 @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;
- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

/**
 快速创建对象方法

 @param title 标题
 @param fontSize 字体大小
 @param titleColor 字体颜色
 @param imageName 图片名
 @param highlightedImageName 高亮状态图片名
 @param target 监听者
 @param action 监听方法
 @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;
- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor imageName:(NSString *)imageName highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;

/**
 快速创建对象方法
 
 @param title 标题
 @param fontSize 字体大小
 @param titleColor 字体颜色
 @param backgroundImageName 背景图片
 @param highlightedBackgroundImageName 高亮状态背景图片
 @param target 监听者
 @param action 监听方法
 @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor backgroundImageName:(NSString *)backgroundImageName highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName target:(id)target action:(SEL)action;
- (instancetype)initWithTitle:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor backgroundImageName:(NSString *)backgroundImageName highlightedBackgroundImageName:(NSString *)highlightedBackgroundImageName target:(id)target action:(SEL)action;

@end
