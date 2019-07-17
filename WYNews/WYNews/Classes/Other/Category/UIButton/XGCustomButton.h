//
//  XGCustomButton.h
//  XGCustomButton
//
//  Created by monkey on 2019/4/5.
//  Copyright © 2019 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, XGButtonImagePosition) {
    XGButtonImagePositionLeft   = 0,     // 图片在文字左侧
    XGButtonImagePositionRight  = 1,     // 图片在文字右侧
    XGButtonImagePositionTop    = 2,     // 图片在文字上侧
    XGButtonImagePositionBottom = 3      // 图片在文字下侧
};

IB_DESIGNABLE
@interface XGCustomButton : UIButton

- (instancetype)initWithImagePosition:(XGButtonImagePosition)imagePosition space:(CGFloat)space;

#if TARGET_INTERFACE_BUILDER // storyBoard/xib中设置
@property (nonatomic,assign) IBInspectable NSInteger imagePosition; // 图片位置
@property (nonatomic, assign) IBInspectable CGFloat imageTitleSpace; // 图片和文字之间的间距
#else // 纯代码设置
@property (nonatomic, assign) XGButtonImagePosition imagePosition; // 图片位置
@property (nonatomic, assign) CGFloat imageTitleSpace; // 图片和文字之间的间距
#endif


@end


NS_ASSUME_NONNULL_END
