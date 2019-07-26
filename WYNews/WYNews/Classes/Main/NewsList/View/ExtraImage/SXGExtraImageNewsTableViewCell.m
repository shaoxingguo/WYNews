//
//  SXGExtraImageNewsTableViewCell.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/19.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <YYWebImage/YYWebImage.h>

#import "SXGExtraImageNewsTableViewCell.h"

#import "SXGNewsViewModel.h"

@interface SXGExtraImageNewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgsrcImageView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *extraImageViewArray;

@end

@implementation SXGExtraImageNewsTableViewCell

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
    _titleLabel.textColor = newsViewModel.isRead ? [UIColor lightGrayColor] : [UIColor blackColor];
    
    __block CGSize size = _imgsrcImageView.size;
    [_imgsrcImageView yy_setImageWithURL:[NSURL URLWithString:newsViewModel.imgsrc] placeholder:nil options:0 progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        return [image yy_imageByResizeToSize:size contentMode:UIViewContentModeScaleAspectFill];
    } completion:nil];
    
    [_extraImageViewArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL * _Nonnull stop) {
        size = imageView.size;
        [imageView yy_setImageWithURL:[NSURL URLWithString:newsViewModel.imgextra[idx]] placeholder:nil options:0 progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
            return [image yy_imageByResizeToSize:size];
        } completion:nil];
    }];
}


@end
