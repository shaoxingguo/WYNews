//
//  UIImage+EXtension.m
//  BSBuDeJie
//
//  Created by monkey on 2018/12/10.
//  Copyright © 2018 itcast. All rights reserved.
//

#import "UIImage+EXtension.h"

@implementation UIImage (EXtension)

- (UIImage *)originalImage
{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)originalImageWithImageName:(NSString *)imageName
{
    
    return [[self imageNamed:imageName] originalImage];
}

- (UIImage *)stretchableImage
{
    return [self stretchableImageWithLeftCapWidth:self.size.width / 2 topCapHeight:self.size.height / 2];
}

+ (UIImage *)stretchableImageWithImageName:(NSString *)imageName
{
    return [[self imageNamed:imageName] stretchableImage];
}

- (UIImage *)circleImage:(CGSize)size backgroundColor:(UIColor *)backgroundColor
{
    // 1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    // 2.绘制背景颜色
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [backgroundColor setFill];
    UIRectFill(rect);
    
    // 3.绘制裁剪区域
    CGPoint center = CGPointMake(size.width / 2, size.height / 2);
    CGFloat radius = fmin(center.x, center.y);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:true];
    [path addClip];
    
    // 4.绘制图片
    [self drawInRect:rect];
    
    // 绘制圆环
    [[UIColor lightGrayColor] setStroke];
    path.lineWidth = 2;
    [path stroke];
    
    // 5.取出图片
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    
     // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    // 7.返回图片
    return circleImage;
}

- (UIImage *)scaleToSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor
{
    // 1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, 0); // 不透明的上下文
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 2.绘制背景颜色
    [backgroundColor setFill];
    UIRectFill(rect);
    
    // 3.绘制图片
    [self drawInRect:rect];
    
    // 4.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    // 6.返回图片
    return newImage;
}



@end
