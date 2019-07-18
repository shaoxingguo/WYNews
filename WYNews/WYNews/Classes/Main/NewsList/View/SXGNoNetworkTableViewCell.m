//
//  SXGNoNetworkTableViewCell.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import "SXGNoNetworkTableViewCell.h"

@implementation SXGNoNetworkTableViewCell

#pragma mark - 构造方法

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor orangeColor];
        self.textLabel.text = @"世界上最遥远的距离就是没有网络!";
        self.textLabel.textColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
