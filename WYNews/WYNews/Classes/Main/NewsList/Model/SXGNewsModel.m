//
//  SXGNewsModel.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "SXGNewsModel.h"

@implementation SXGNewsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"bigImage" : @"imgType"};
}

@end
