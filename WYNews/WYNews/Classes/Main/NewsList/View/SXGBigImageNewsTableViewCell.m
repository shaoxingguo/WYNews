//
//  SXGBigImageNewsTableViewCell.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/19.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <YYWebImage/YYWebImage.h>

#import "SXGBigImageNewsTableViewCell.h"

#import "SXGNewsViewModel.h"

@interface SXGBigImageNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgsrcImageView;

@end

@implementation SXGBigImageNewsTableViewCell

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
    
    _titleLabel.text = newsViewModel.title;
    [_imgsrcImageView yy_setImageWithURL:[NSURL URLWithString:newsViewModel.imgsrc] placeholder:nil options:0 progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return [image yy_imageByResizeToSize:self->_imgsrcImageView.size contentMode:UIViewContentModeScaleAspectFill];
    } completion:nil];
}


@end
