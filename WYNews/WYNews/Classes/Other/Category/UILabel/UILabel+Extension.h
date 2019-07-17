//
//  UILabel+Extension.h
//  02-自定义不等高cell
//
//  Created by monkey on 2018/7/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

- (instancetype)initWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment;

/**
 便利创建对象方法

 @param text 文本内容
 @param textColor 字体颜色
 @param font 字体大小
 @param  textAlignment 文本对齐方式
 @return UILabel对象
 */
+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment;

@end
