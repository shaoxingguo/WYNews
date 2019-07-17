//
//  UILabel+Extension.m
//  02-自定义不等高cell
//
//  Created by monkey on 2018/7/19.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

#pragma mark - 构造方法

- (instancetype)initWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment
{
    if (self = [super init]) {
        self.text = text;
        self.font = [UIFont systemFontOfSize:font];
        self.textColor = textColor;
        self.textAlignment = textAlignment;
        self.numberOfLines = 0;
        [self sizeToFit];
    }
    
    return self;
}

+ (instancetype)labelWithText:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font textAlignment:(NSTextAlignment)textAlignment;
{
    return [[self alloc] initWithText:text textColor:textColor font:font textAlignment:textAlignment];
}

@end
