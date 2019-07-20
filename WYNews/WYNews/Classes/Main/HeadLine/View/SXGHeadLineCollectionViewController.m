//
//  SXGHeadLineCollectionViewController.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/18.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <MJExtension/MJExtension.h>

#import "SXGHeadLineCollectionViewController.h"

#import "SXGHeadLineCollectionViewCell.h"

#import "SXGNewsDAL.h"

#import "SXGHeadLineModel.h"
#import "SXGNewsTopicModel.h"

#pragma mark - SXGHeadLineCollectionViewFlowLayout

@interface SXGHeadLineCollectionViewFlowLayout : UICollectionViewFlowLayout

@end

@implementation SXGHeadLineCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = self.collectionView.size;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
    
    self.collectionView.bounces = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end

#pragma mark - SXGHeadLineCollectionViewController

static NSString *kSXGHeadLineCollectionViewCellReuseIdentifier = @"SXGHeadLineCollectionViewCell";

@implementation SXGHeadLineCollectionViewController
{
    /// 新闻话题数据模型
    SXGNewsTopicModel *_newsTopicModel;
    /// 头条数据模型数组
    NSArray<SXGHeadLineModel *> *_headLineModelaArr;
    /// 当前头条索引
    NSInteger _currentIndex;
    /// 定时器
    NSTimer *_timer;
}

#pragma mark - 构造方法

- (instancetype)init
{
    SXGHeadLineCollectionViewFlowLayout *flowLayout = [[SXGHeadLineCollectionViewFlowLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:flowLayout]) {
        
    }
    
    return self;
}

#pragma mark - 开放方法

- (void)refresh
{
    [self stopTimer];
    [self loadHeadLineData];
}

#pragma mark - 控制器生命周期方法

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SXGHeadLineCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kSXGHeadLineCollectionViewCellReuseIdentifier];;
}

- (void)dealloc
{
    [self stopTimer];
}

#pragma mark - 数据源和代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _headLineModelaArr.count * 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SXGHeadLineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSXGHeadLineCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.item % _headLineModelaArr.count;
    cell.tag = index;
    cell.headLineModel = _headLineModelaArr[index];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 0 1 2 3 4
    // 5 6 7 8 9
    NSInteger item = scrollView.contentOffset.x / scrollView.width;
    if (item == [self.collectionView numberOfItemsInSection:0] - 1) {
        // 滚动到最后一页 偷偷滚动到第0组最后一页
        item = _headLineModelaArr.count - 1;
    } else if (item == 0) {
        // 滚动到第0页 偷偷滚动到最后一组第0页
        item = [self.collectionView numberOfItemsInSection:0] - _headLineModelaArr.count;
    }
    
    _currentIndex = item;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    if (_timer == nil) {
        [self startTimer];
    }
}

#pragma mark - 其他私有方法

- (void)loadHeadLineData
{
    NSString *tid = _newsTopicModel != nil ? _newsTopicModel.tid : @"T1348647853363";
    [SXGNewsDAL loadHeadLineListWithTid:tid completion:^(id  _Nullable responseObject) {
        if (responseObject == nil || [responseObject count] == 0) {
            return;
        }
        
        self->_headLineModelaArr = [SXGHeadLineModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.collectionView reloadData];
        // 滚动到第1组第0页
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_currentIndex = self->_headLineModelaArr.count;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self->_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [self startTimer];
        });
    }];
}

- (void)startTimer
{
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer timerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf nextPage];
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)nextPage
{
    _currentIndex++;
    if (_currentIndex == [self.collectionView numberOfItemsInSection:0] - 1) {
        // 滚动到最后一页 先偷偷滚动到第0组倒数第二页
        _currentIndex = _headLineModelaArr.count - 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)setNewsTopicModel:(SXGNewsTopicModel *)newsTopicModel
{
    [self reset];
    
    if (_newsTopicModel != newsTopicModel) {
        _newsTopicModel = newsTopicModel;
        [self loadHeadLineData];
    } else {
        [self startTimer];
    }
}

- (void)reset
{
    if (_timer != nil) {
        [self stopTimer];
        self->_currentIndex = self->_headLineModelaArr.count;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self->_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

@end


