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

/// 选中的话题按钮尺寸
static const CGFloat kSelectedNewsTopicButtonScale = 1.5f;

@interface SXGHomeViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    /// 新闻话题模型数组
    NSArray<SXGNewsTopicModel *> *_newsTopicArr;
    
    /// 话题滚动视图
    UIScrollView *_newsTopicScrollView;
    /// 选中的话题按钮
    UIButton *_selectedNewsTopicButton;
    /// 新闻列表滚动视图
    UICollectionView *_newsListCollectionView;
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
        
        // 选中第一个话题
        [self scrollViewDidScroll:self->_newsListCollectionView];
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
    // 切换话题
    _selectedNewsTopicButton.selected = NO;
    button.selected = YES;
    _selectedNewsTopicButton = button;
    
    CGFloat offset = (button.centerX - [SXGCommon shared].screenWidth / 2);
    CGFloat minOffset = 0;
    CGFloat maxOffset = _newsTopicScrollView.contentSize.width - _newsTopicScrollView.width;
    if (offset < minOffset) {
        offset = minOffset;
    } else if (offset > maxOffset) {
        offset = maxOffset;
    }
    
    [_newsTopicScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    [_newsListCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
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
    SXGNewsListCollectionViewCell *cell = (SXGNewsListCollectionViewCell *)[_newsListCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    cell.newsTopicModel = _newsTopicArr[index];
    
    UIButton *button = _newsTopicScrollView.subviews[index];
    if (button != _selectedNewsTopicButton) {
        [self newsTopicButtonAction:button];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray<NSIndexPath *>* visibleIndexPaths = [_newsListCollectionView indexPathsForVisibleItems];
    UIButton *nextNewsTopicButton = nil;
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        if (indexPath.item != _selectedNewsTopicButton.tag) {
            nextNewsTopicButton = _newsTopicScrollView.subviews[indexPath.item];
            break;
        }
    }
    
    // 设置颜色渐变
    CGFloat offsetX = fabs(scrollView.contentOffset.x - _selectedNewsTopicButton.tag * scrollView.width);
    CGFloat nextScale = offsetX / scrollView.width;
    CGFloat currentScale = (1 - nextScale);
    [_selectedNewsTopicButton setTitleColor:[UIColor colorWithDisplayP3Red:currentScale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    [nextNewsTopicButton setTitleColor:[UIColor colorWithDisplayP3Red:nextScale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    
    // 设置尺寸缩放
    CGFloat currentTransformScale = (kSelectedNewsTopicButtonScale - 1) * currentScale + 1;
    CGFloat nextTransformScale = (kSelectedNewsTopicButtonScale - 1) * nextScale + 1;
    _selectedNewsTopicButton.transform = CGAffineTransformMakeScale(currentTransformScale, currentTransformScale);
    nextNewsTopicButton.transform = CGAffineTransformMakeScale(nextTransformScale, nextTransformScale);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidScroll:scrollView];
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
    [self.view addSubview:_newsTopicScrollView];
    
    CGFloat width = ceil(self.view.width / 6);  // 按钮宽度 一页显示6个按钮
    [self.newsTopicArr enumerateObjectsUsingBlock:^(SXGNewsTopicModel * _Nonnull newsTopicModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithTitle:newsTopicModel.tname fontSize:15 titleColor:SXG_News_Topic_Normal_Color target:self action:@selector(newsTopicButtonAction:)];
        button.tag = idx;
        button.backgroundColor = [UIColor whiteColor];
        [self->_newsTopicScrollView addSubview:button];
        button.frame = CGRectMake(width * idx, 0, width, self->_newsTopicScrollView.height);
        
        if (idx == 0) {
            self->_selectedNewsTopicButton = button;
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
