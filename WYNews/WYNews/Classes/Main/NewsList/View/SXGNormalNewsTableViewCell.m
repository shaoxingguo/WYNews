//
//  SXGNormalNewsTableViewCell.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <YYWebImage/YYWebImage.h>

#import "SXGNormalNewsTableViewCell.h"

#import "SXGNewsModel.h"

@interface SXGNormalNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgsrcImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *digestLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;

@end

@implementation SXGNormalNewsTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)setNewsModel:(SXGNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    [_imgsrcImageView yy_setImageWithURL:[NSURL URLWithString:newsModel.imgsrc] placeholder:nil options:0 progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return [image yy_imageByResizeToSize:CGSizeMake(80, 60)];
    } completion:nil];
    _titleLabel.text = newsModel.title;
    _digestLabel.text = newsModel.digest;
    _postTimeLabel.text = newsModel.ptime;
}

@end
