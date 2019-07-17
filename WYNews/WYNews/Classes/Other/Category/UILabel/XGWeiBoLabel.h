//
//  XGWeiBoLabel.h
//  GZKit
//
//  Created by xinshijie on 17/3/22.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , XGWeiBoLabelStyle)
{
    XGWeiBoLabelStyleNone = 0,
    XGWeiBoLabelStyleUser = 1,
    XGWeiBoLabelStyleTopic = 2,
    XGWeiBoLabelStyleLink = 3,
    XGWeiBoLabelStyleAgreement = 4,
    XGWeiBoLabelStyleUserDefine = 5,
    XGWeiBoLabelStylePhoneNumber = 6
};

@class XGWeiBoLabel;

@protocol XGWeiBoLabelDelegate <NSObject>

@optional

/// 代理方法 点击超链接文字
- (void)weiBoLabel:(XGWeiBoLabel *)label didSelectedString:(NSString *)selectedString forXGWeiBoLabelStyle:(XGWeiBoLabelStyle)style;

@end

// Block
typedef void(^TapXGWeiBoLabel)(UILabel *,XGWeiBoLabelStyle, NSString * , NSRange);

@interface XGWeiBoLabel : UILabel

/// 普通文字颜色
@property(nonatomic , strong) UIColor *normalTextColor;

/// 选中时高亮背景色
@property(nonatomic , strong) UIColor *selectedBackgroundColor;

/// 高亮颜色
@property (nonatomic,strong) UIColor *linkColor;

/// 字符串+显示颜色 字典数组
@property(nonatomic, strong) NSArray<NSDictionary *> *customerMatchArr;

/// delegate
@property(nonatomic, weak)id<XGWeiBoLabelDelegate> delegate;

/// 点击事件block
@property(nonatomic, strong)TapXGWeiBoLabel tapOperation;

@end
