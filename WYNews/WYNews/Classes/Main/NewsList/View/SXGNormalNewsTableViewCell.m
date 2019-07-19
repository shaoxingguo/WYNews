//
//  SXGNormalNewsTableViewCell.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <YYWebImage/YYWebImage.h>

#import "SXGNormalNewsTableViewCell.h"

#import "SXGNewsViewModel.h"

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
    
    self.layer.drawsAsynchronously = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)setNewsViewModel:(SXGNewsViewModel *)newsViewModel
{
    _newsViewModel = newsViewModel;
    
    [_imgsrcImageView yy_setImageWithURL:[NSURL URLWithString:newsViewModel.imgsrc] placeholder:nil options:0 progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return [image yy_imageByResizeToSize:CGSizeMake(80,60) contentMode: UIViewContentModeScaleAspectFill];
    } completion: nil];
    _titleLabel.text = newsViewModel.title;
    _digestLabel.text = newsViewModel.digest;
    _postTimeLabel.text = newsViewModel.postime;
    _replyCountLabel.text = newsViewModel.replyCount;
}

@end
