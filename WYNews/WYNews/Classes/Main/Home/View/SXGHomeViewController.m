//
//  SXGHomeViewController.m
//  WYNews
//
//  Created by shaoxingguo on 2019/7/17.
//  Copyright © 2019 shaoxingguo. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <YYWebImage/YYWebImage.h>

#import "SXGHomeViewController.h"
#import "SXGHeadLineCollectionViewController.h"

#import "SXGNewsListCollectionViewCell.h"

#import "SXGNewsTopicModel.h"

static NSString *const kSXGNewsListCollectionViewCellReuseIdentifier = @"SXGNewsListCollectionViewCell";

#define SXG_News_Topic_Normal_Color  [UIColor blackColor]
#define SXG_News_Topic_Selected_Color [UIColor redColor]

static const CGFloat kSelectedNewsTopicButtonScale = 1.5f;

@interface SXGHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    /// 新闻话题模型数组
    NSArray<SXGNewsTopicModel *> *_newsTopicArr;
    
    /// 话题滚动视图
    UIScrollView *_newsTopicScrollView;
    /// 新闻列表滚动视图
    UICollectionView *_newsListCollectionView;
    /// 上一个话题索引
    NSInteger _previousNewsTopicIndex;
    /// 当前话题索引
    NSInteger _currentNewsTopicIndex;
}

@end

@implementation SXGHomeViewController

#pragma mark - 控制器生命周期方法

- (void)loadView
{
    [super loadView];
    
    [self setUpUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"网易新闻";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 赋值数据模型 加载数据
        NSIndexPath *indexPath = [self->_newsListCollectionView indexPathsForVisibleItems].lastObject;
        SXGNewsListCollectionViewCell *cell = (SXGNewsListCollectionViewCell *)[self->_newsListCollectionView cellForItemAtIndexPath:indexPath];
        cell.newsTopicModel = self->_newsTopicArr[indexPath.item];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
}

#pragma mark - 事件监听

- (void)newsTopicButtonAction:(UIButton *)button
{
    // 重复点击同一个话题
    if (_currentNewsTopicIndex == button.tag) {
        return;
    }
    
    // 切换话题
    _previousNewsTopicIndex = _currentNewsTopicIndex;
    UIButton *previousNewsTopicButton = _newsTopicScrollView.subviews[_previousNewsTopicIndex];
    previousNewsTopicButton.selected = NO;
    button.selected = YES;
    _currentNewsTopicIndex = button.tag;
    
    CGFloat offset = (button.centerX - [SXGCommon shared].screenWidth / 2);
    CGFloat minOffset = 0;
    CGFloat maxOffset = _newsTopicScrollView.contentSize.width - _newsTopicScrollView.width;
    if (offset < minOffset) {
        offset = minOffset;
    } else if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    // 话题滚动视图滚动到对于的话题
    [_newsTopicScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    // 新闻滚动视图滚动到对于的话题模块
    [_newsListCollectionView setContentOffset:CGPointMake(_currentNewsTopicIndex * _newsListCollectionView.width, 0) animated:YES];
}

#pragma mark - 数据源和代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _newsTopicArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SXGNewsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSXGNewsListCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    // 没有滑动到别的模块 还处于当前模块
    if (index == _currentNewsTopicIndex) {
        return;
    }
    
    // 切换到别的话题
    SXGNewsListCollectionViewCell *cell = (SXGNewsListCollectionViewCell *)[_newsListCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    cell.newsTopicModel = _newsTopicArr[index];
    UIButton *button = _newsTopicScrollView.subviews[index];
    [self newsTopicButtonAction:button];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSArray<NSIndexPath *> *visibleIndexPaths = [_newsListCollectionView indexPathsForVisibleItems];
    if (visibleIndexPaths.count < 2) {
        return;
    } else if (ABS(_currentNewsTopicIndex - _previousNewsTopicIndex) > 1) {
        // 如果是通过点击话题滚动视图来切换 此时两个模块之间索引差很大 通过滚动动画结束来处理
        return;
    } else {
        // 如果是慢慢滚动 在此进行处理
        UIButton *nextNewsTopicButton = nil;
        UIButton *currentNewsTopicButton = _newsTopicScrollView.subviews[_currentNewsTopicIndex];
        for (NSIndexPath *indexPath in visibleIndexPaths) {
            if (indexPath.item != _currentNewsTopicIndex) {
                nextNewsTopicButton = _newsTopicScrollView.subviews[indexPath.item];
                break;
            }
        }
        
        // 设置颜色渐变
        CGFloat offsetX = fabs(scrollView.contentOffset.x - _currentNewsTopicIndex * scrollView.width);
        CGFloat nextScale = offsetX / scrollView.width;
        CGFloat currentScale = (1 - nextScale);
        [currentNewsTopicButton setTitleColor:[UIColor colorWithDisplayP3Red:currentScale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        [nextNewsTopicButton setTitleColor:[UIColor colorWithDisplayP3Red:nextScale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        
        // 设置尺寸缩放
        CGFloat currentTransformScale = (kSelectedNewsTopicButtonScale - 1) * currentScale + 1;
        CGFloat nextTransformScale = (kSelectedNewsTopicButtonScale - 1) * nextScale + 1;
        currentNewsTopicButton.transform = CGAffineTransformMakeScale(currentTransformScale, currentTransformScale);
        nextNewsTopicButton.transform = CGAffineTransformMakeScale(nextTransformScale, nextTransformScale);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    UIButton *previousNewsTopicButton = _newsTopicScrollView.subviews[_previousNewsTopicIndex];
    UIButton *currentNewsTopicButton = _newsTopicScrollView.subviews[_currentNewsTopicIndex];
    [previousNewsTopicButton setTitleColor:SXG_News_Topic_Normal_Color forState:UIControlStateNormal];
    [currentNewsTopicButton setTitleColor:SXG_News_Topic_Selected_Color forState:UIControlStateNormal];
    previousNewsTopicButton.transform = CGAffineTransformIdentity;
    currentNewsTopicButton.transform = CGAffineTransformMakeScale(kSelectedNewsTopicButtonScale, kSelectedNewsTopicButtonScale);
    _previousNewsTopicIndex = _currentNewsTopicIndex;
    
    SXGNewsListCollectionViewCell *cell = (SXGNewsListCollectionViewCell *)[_newsListCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_currentNewsTopicIndex inSection:0]];
    cell.newsTopicModel = _newsTopicArr[_currentNewsTopicIndex];
}

#pragma mark - 内部其他私有方法

- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareNewsTopicScrollView];
    [self prepareNewsListCollectionView];
}

- (void)prepareNewsTopicScrollView
{
    _newsTopicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [SXGCommon shared].navigationBarHeight, [SXGCommon shared].screenWidth, 44)];
    _newsTopicScrollView.backgroundColor = [UIColor whiteColor];
    _newsTopicScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _newsTopicScrollView.showsHorizontalScrollIndicator = NO;
    _newsTopicScrollView.showsVerticalScrollIndicator = NO;
    _newsTopicScrollView.bounces = NO;
    _newsTopicScrollView.scrollsToTop = NO;
    [self.view addSubview:_newsTopicScrollView];
    
    CGFloat width = ceil(self.view.width / 6);  // 按钮宽度 一页显示6个按钮
    [self.newsTopicArr enumerateObjectsUsingBlock:^(SXGNewsTopicModel * _Nonnull newsTopicModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithTitle:newsTopicModel.tname fontSize:15 titleColor:SXG_News_Topic_Normal_Color target:self action:@selector(newsTopicButtonAction:)];
        button.tag = idx;
        button.backgroundColor = [UIColor whiteColor];
        [self->_newsTopicScrollView addSubview:button];
        button.frame = CGRectMake(width * idx, 0, width, self->_newsTopicScrollView.height);
        
        if (idx == 0) {
            button.transform = CGAffineTransformMakeScale(kSelectedNewsTopicButtonScale, kSelectedNewsTopicButtonScale);
            [button setTitleColor:SXG_News_Topic_Selected_Color forState:UIControlStateNormal];
        }
    }];
    
    _newsTopicScrollView.contentSize = CGSizeMake(width * _newsTopicArr.count, 0);
}

- (void)prepareNewsListCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat y = CGRectGetMaxY(_newsTopicScrollView.frame);
    _newsListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, [SXGCommon shared].screenWidth, self.view.height - y - [SXGCommon shared].bottomMargin) collectionViewLayout:flowLayout];
    _newsListCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_newsListCollectionView];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = _newsListCollectionView.size;
    flowLayout.minimumLineSpacing = 0;
    
    _newsListCollectionView.pagingEnabled = YES;
    _newsListCollectionView.bounces = NO;
    _newsListCollectionView.showsHorizontalScrollIndicator = NO;
    _newsListCollectionView.dataSource = self;
    _newsListCollectionView.delegate = self;
    _newsListCollectionView.scrollsToTop = NO;
    
    [_newsListCollectionView registerClass:[SXGNewsListCollectionViewCell class] forCellWithReuseIdentifier:kSXGNewsListCollectionViewCellReuseIdentifier];
}

#pragma mark - 懒加载

- (NSArray<SXGNewsTopicModel *> *)newsTopicArr
{
    if (!_newsTopicArr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray<SXGNewsTopicModel *> *arrM = [SXGNewsTopicModel mj_objectArrayWithKeyValuesArray:dict[@"tList"]];
        [arrM sortUsingComparator:^NSComparisonResult(SXGNewsTopicModel *obj1, SXGNewsTopicModel *obj2) {
            return [obj1.tid compare:obj2.tid];
        }];
        
        _newsTopicArr = [arrM copy];
    }
    
    return _newsTopicArr;
}

@end

#undef SXG_News_Topic_Normal_Color
#undef SXG_News_Topic_Selected_Color
