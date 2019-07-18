//
//  SXGHeadLineCollectionViewCell.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <YYWebImage/YYWebImage.h>

#import "SXGHeadLineCollectionViewCell.h"

#import "SXGHeadLineModel.h"

@interface SXGHeadLineCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation SXGHeadLineCollectionViewCell

- (void)setHeadLineModel:(SXGHeadLineModel *)headLineModel
{
    _headLineModel = headLineModel;
    
    _titleLabel.text = headLineModel.title;
    _pageControl.currentPage = self.tag;
    [_imageView yy_setImageWithURL:[NSURL URLWithString:headLineModel.imgsrc] options: YYWebImageOptionProgressive];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}


@end
