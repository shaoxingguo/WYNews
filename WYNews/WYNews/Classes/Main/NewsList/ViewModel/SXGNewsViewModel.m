//
//  SXGNewsViewModel.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import "SXGNewsViewModel.h"

#import "SXGNewsModel.h"

@implementation SXGNewsViewModel
{
    SXGNewsModel *_newsModel;
    NSString *_replyCountString;
}

#pragma mark - 开放方法

- (instancetype)initWithNewsModel:(SXGNewsModel *)newsModel
{
    if (self = [super init]) {
        _newsModel = newsModel;
        [self initializeSetting];
    }
    
    return self;
}

+ (instancetype)viewModelWithNewsModel:(SXGNewsModel *)newsModel
{
    return [[self alloc] initWithNewsModel:newsModel];
}

+ (NSArray<SXGNewsViewModel *> *)viewModelArrayWithNewsModelArray:(NSArray<SXGNewsModel *> *)newsModelArr
{
    NSMutableArray<SXGNewsViewModel *> *arrM = [NSMutableArray arrayWithCapacity:newsModelArr.count];
    for (SXGNewsModel *newsModel in newsModelArr) {
        [arrM addObject:[self viewModelWithNewsModel:newsModel]];
    }
    
    return arrM;
}


- (NSString *)title
{
    return _newsModel.title;
}

- (NSString *)postime
{
    return _newsModel.ptime;
}

- (NSString *)replyCount
{
    return _replyCountString;
}

- (NSString *)docid
{
    return _newsModel.docid;
}

- (NSString *)digest
{
    return _newsModel.digest;
}

- (NSString *)imgsrc
{
    return _newsModel.imgsrc;
}

- (NSArray<NSString *> *)imgextra
{
    if (_newsModel.imgextra != nil) {
        NSString *extra1 = _newsModel.imgextra.firstObject[@"imgsrc"];
        NSString *extra2 = _newsModel.imgextra.lastObject[@"imgsrc"];
        return @[extra1,extra2];
    }
    
    return nil;
}

- (BOOL)isBigImage
{
    return _newsModel.imgType == 1;
}

- (BOOL)isRead
{
    return _newsModel.isRead;
}

- (void)setRead:(BOOL)read
{
    _newsModel.read = read;
}

#pragma mark - 内部其他私有方法

- (void)initializeSetting
{
    if (_newsModel.replyCount < 10000) {
        _replyCountString = [NSString stringWithFormat:@"%zd 人回复",_newsModel.replyCount];
    } else {
        NSMutableString *tmpStringM = [NSMutableString stringWithFormat:@"%.2f 万人回复",_newsModel.replyCount / 10000.f];
        NSRange range = [tmpStringM rangeOfString:@".00" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            [tmpStringM replaceCharactersInRange:range withString:@""];
        } else {
            range = [tmpStringM rangeOfString:@"0" options:NSBackwardsSearch];
            if (range.location != NSNotFound) {
                [tmpStringM replaceCharactersInRange:range withString:@""];
            }
        }
        
        _replyCountString = [tmpStringM copy];
    }
}

@end
