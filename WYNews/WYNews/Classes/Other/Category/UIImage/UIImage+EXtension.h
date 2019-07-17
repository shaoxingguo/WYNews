//
//  UIImage+EXtension.h
//  BSBuDeJie
//
//  Created by monkey on 2018/12/10.
//  Copyright © 2018 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (EXtension)


/**
 创建没有渲染的图片

 @param imageName 图片名称
 @return UIImage
 */
+ (UIImage *)originalImageWithImageName:(NSString *)imageName;
- (UIImage *)originalImage;


/**
 创建不拉伸的图片

 @param imageName 图片mingc
 @return UIImage
 */
+ (UIImage *)stretchableImageWithImageName:(NSString *)imageName;
- (UIImage *)stretchableImage;

/**
 返回一张圆形图片
 
 @param size 图片大小
 @param backgroundColor 背景颜色
 @return UIImage
 */
- (UIImage *)circleImage:(CGSize)size backgroundColor:(UIColor *)backgroundColor;


/**
 缩放图片至指定大小

 @param size 图片大小
 @param backgroundColor 背景颜色
 @return UIImage
 */
- (UIImage *)scaleToSize:(CGSize)size backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
