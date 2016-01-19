//
//  PIESearchPageViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 12/18/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIESearchPageViewController.h"
#import "PIERefreshCollectionView.h"
#import "PIESearchContentCollectionViewCell.h"
#import "PIESearchManager.h"
#import "PIEFriendViewController.h"
#import "PIECarouselViewController2.h"
@interface PIESearchPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,PWRefreshBaseCollectionViewDelegate>
@property (nonatomic, strong) PIERefreshCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray* source;
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *layout;
@property (nonatomic, assign) BOOL notFirstLoading;
@property (nonatomic, assign)  long long timeStamp;
@property (nonatomic, assign)  NSInteger currentPage;

@end

@implementation PIESearchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextToSearch:(NSString *)textToSearch {
    _textToSearch = textToSearch;
    [self search];
}
- (void)search {
    if ([_collectionView.mj_header isRefreshing] == NO) {
        NSMutableDictionary* param = [NSMutableDictionary new];
        [param setObject:@(1) forKey:@"page"];
        [param setObject:@(10) forKey:@"size"];
        _timeStamp = [[NSDate date] timeIntervalSince1970];
        [param setObject:@(_timeStamp) forKey:@"last_updated"];
        [param setObject:_textToSearch forKey:@"desc"];
        [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
        [PIESearchManager getSearchContentResult:param withBlock:^(NSMutableArray *retArray) {
            _notFirstLoading = YES;
            [_source removeAllObjects];
            _source = retArray;
            [_collectionView reloadData];
        }];
    }
    
}
- (void)searchMore {
    _currentPage ++;
    NSMutableDictionary* param = [NSMutableDictionary new];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(10) forKey:@"size"];
    [param setObject:@(_timeStamp) forKey:@"last_updated"];
    [param setObject:_textToSearch forKey:@"desc"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [PIESearchManager getSearchContentResult:param withBlock:^(NSMutableArray *retArray) {
        [_source addObjectsFromArray: retArray];
        [_collectionView reloadData];
        if (retArray.count<=0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.collectionView.mj_footer endRefreshing];
        }
    }];
}

-(PIERefreshCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[PIERefreshCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        UINib* nib = [UINib nibWithNibName:@"PIESearchContentCollectionViewCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIESearchContentCollectionViewCell"];
        _collectionView.toRefreshTop = NO;
        _collectionView.toRefreshBottom = YES;
        _collectionView.psDelegate = self;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.emptyDataSetDelegate = self;
        _collectionView.emptyDataSetSource = self;
        _collectionView.collectionViewLayout = self.layout;
        _collectionView.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
                UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnCollectionView:)];
                [_collectionView addGestureRecognizer:tapGesture];
        

    }
    return _collectionView;
}
- (void)tapOnCollectionView:(UITapGestureRecognizer*)gesture {
    
        CGPoint location = [gesture locationInView:self.collectionView];
        NSIndexPath* selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];

        if (selectedIndexPath) {
            PIEPageVM* vm = [_source objectAtIndex:selectedIndexPath.row];
            PIESearchContentCollectionViewCell* cell = (PIESearchContentCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectedIndexPath];
            CGPoint p = [gesture locationInView:cell];
            if (CGRectContainsPoint(cell.avatarButton.frame, p) || CGRectContainsPoint(cell.nameLabel.frame, p)) {
                PIEFriendViewController* vc = [PIEFriendViewController new];
                vc.pageVM = vm;
                [self.parentViewController.view.superview.viewController.navigationController pushViewController:vc animated:YES];
            } else if (CGRectContainsPoint(cell.imageView.frame, p)) {
                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                vc.pageVM = vm;
                [self.parentViewController.view.superview.viewController.navigationController  presentViewController:vc animated:YES completion:nil];
                //                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    
}

-(CHTCollectionViewWaterfallLayout *)layout {
    if (!_layout) {
        _layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _layout.columnCount = 2;
        _layout.minimumInteritemSpacing = 10;
        _layout.minimumColumnSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
    }
    return _layout;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _source.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PIESearchContentCollectionViewCell *cell =
    (PIESearchContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIESearchContentCollectionViewCell"
                                                                                    forIndexPath:indexPath];
    [cell injectSauce:[_source objectAtIndex:indexPath.row]];
    return cell;

    
    return nil;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
    //    vc.pageVM = [_sourceDone objectAtIndex:indexPath.row];
    //    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    //    [nav pushViewController:vc animated:YES ];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        PIEPageVM* vm =[_source objectAtIndex:indexPath.row];
        CGFloat width;
        CGFloat height;
        width = SCREEN_WIDTH/2 - 20;
        height = vm.imageRatio * width + 110;
        height = MAX(height, 50);
        height = MIN(height, SCREEN_HEIGHT/1.5);
        return CGSizeMake(width, height);
}

#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"抱歉！暂时没有找到你想要的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return _notFirstLoading;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -100;
}

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
        [self searchMore];
}


@end
