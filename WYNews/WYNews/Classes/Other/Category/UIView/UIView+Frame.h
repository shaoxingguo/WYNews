//
//  UIView+Frame.h
//  Lottery
//
//  Created by monkey on 2018/9/23.
//  Copyright © 2018年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/** 尺寸 */
@property (nonatomic,assign) CGSize size;
/** 宽度 */
@property (nonatomic,assign) CGFloat width;
/** 高度 */
@property (nonatomic,assign) CGFloat height;
/** 位置 */
@property (nonatomic,assign) CGPoint origin;
/** X点 */
@property (nonatomic,assign) CGFloat x;
/** y点 */
@property (nonatomic,assign) CGFloat y;
/** centerX */
@property (nonatomic,assign) CGFloat centerX;
/** centerY */
@property (nonatomic,assign) CGFloat centerY;

@end
