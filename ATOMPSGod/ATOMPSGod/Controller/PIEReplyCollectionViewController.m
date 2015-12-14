//
//  PIEReplyCollectionViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/2/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEReplyCollectionViewController.h"
#import "DDHotDetailManager.h"
#import "PIERefreshCollectionView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEReplyCollectionCell.h"
#import "PIECarouselViewController2.h"
#import "PIEFriendViewController.h"
@interface PIEReplyCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,PWRefreshBaseCollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFoot;
@property (nonatomic, strong) PIERefreshCollectionView* collectionView;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

@end

@implementation PIEReplyCollectionViewController

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"其它作品";
    self.view = self.collectionView;
    _source = [NSMutableArray array];
    _canRefreshFoot = YES;
    [self getRemoteSource];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"进入其它作品页"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"离开其它作品页"];
}
- (void)getRemoteSource {
    _currentPage = 1;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    DDHotDetailManager *manager = [DDHotDetailManager new];
    [manager fetchAllReply:param ID:_pageVM.askID withBlock:^(NSMutableArray *askArray, NSMutableArray *replyArray) {
        if (replyArray.count>0) {
//            NSMutableArray* arrayAgent = [NSMutableArray new];
//            for (PIEPageEntity *entity in replyArray) {
//                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:entity];
//                [arrayAgent addObject:vm];
//            }
            [_source removeAllObjects];
            [_source addObjectsFromArray:replyArray];
            [self.collectionView reloadData];
            _canRefreshFoot = YES;
        }
        else {
            _canRefreshFoot = NO;
        }
        [self.collectionView.mj_header endRefreshing];
    }];
}
- (void)getMoreRemoteSource {
    _currentPage ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    DDHotDetailManager *manager = [DDHotDetailManager new];
    [manager fetchAllReply:param ID:_pageVM.askID withBlock:^(NSMutableArray *askArray, NSMutableArray *replyArray) {
            if (replyArray.count>0) {
                [_source addObjectsFromArray:replyArray];
                [self.collectionView reloadData];
                _canRefreshFoot = YES;
            }
            else {
                _canRefreshFoot = NO;
            }
//        }
        [self.collectionView.mj_footer endRefreshing];
    }];
}

-(PIERefreshCollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 6, 0, 6);
        layout.minimumColumnSpacing = 8;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[PIERefreshCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.toRefreshBottom = YES;
        _collectionView.toRefreshTop = YES;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.psDelegate = self;
        UINib* nib = [UINib nibWithNibName:@"PIEReplyCollectionCell" bundle:nil];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"PIEReplyCollectionCell"];
        
//        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCollectionView:)];
//        [_collectionView addGestureRecognizer:tapGesture];

    }
    return _collectionView;
}
//- (void)tapOnCollectionView:(UITapGestureRecognizer *)gesture {
//        CGPoint location = [gesture locationInView:self.collectionView];
//        _selectedIndexPath = [self.collectionView indexPathForItemAtPoint:location];
//    
//        if (_selectedIndexPath) {
//            PIEPageVM* vm = [_source objectAtIndex:_selectedIndexPath.row];
//            PIEReplyCollectionCell* cell = (PIEReplyCollectionCell*)[self.collectionView cellForItemAtIndexPath:_selectedIndexPath];
//            CGPoint p = [gesture locationInView:cell];
//            if (CGRectContainsPoint(cell.avatarView.frame, p) || CGRectContainsPoint(cell.usernameLabel.frame, p)) {
//                PIEFriendViewController* vc = [PIEFriendViewController new];
//                vc.pageVM = vm;
//                [self.navigationController pushViewController:vc animated:YES];
//            } else if (CGRectContainsPoint(cell.imageView.frame, p)) {
//                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
//                vc.pageVM = vm;
//                [self.navigationController pushViewController:vc animated:YES];
//            } else {
//                CGPoint q = [gesture locationInView:cell.bottomView];
//                if (CGRectContainsPoint(cell.likeButton.frame, q)) {
//                    [self like];
//                }
//            }
//    
//            
//        }
//}

- (void)like {
    NSLog(@"like");
    PIEPageVM* vm = [_source objectAtIndex:_selectedIndexPath.row];
    PIEReplyCollectionCell* cell = (PIEReplyCollectionCell*)[self.collectionView cellForItemAtIndexPath:_selectedIndexPath];

    cell.likeButton.selected = !cell.likeButton.selected;
    [DDService toggleLike:cell.likeButton.selected ID:vm.ID type:vm.type withBlock:^(BOOL success) {
        if (!success) {
            cell.likeButton.selected = !cell.likeButton.selected;
        } else {
            
            if (cell.likeButton.selected) {
                vm.likeCount = [NSString stringWithFormat:@"%zd",vm.likeCount.integerValue + 1];
            } else {
                vm.likeCount = [NSString stringWithFormat:@"%zd",vm.likeCount.integerValue - 1];
            }
            vm.liked = cell.likeButton.selected;
        }
    }];
}

#pragma mark - refresh delegate

-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
        [self getRemoteSource];
}

-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    if (collectionView == _collectionView) {
        if (_canRefreshFoot) {
            [self getMoreRemoteSource];
        } else {
            [_collectionView.mj_footer endRefreshing];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _collectionView) {
        return _source.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _collectionView) {
        PIEReplyCollectionCell *cell =
        (PIEReplyCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIEReplyCollectionCell"
                                                                            forIndexPath:indexPath];
        [cell injectSauce:[_source objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_source objectAtIndex:indexPath.row];
    PIECarouselViewController2* vc = [PIECarouselViewController2 new];
    vc.pageVM = vm;
    [self.navigationController presentViewController:vc animated:YES completion:nil];

//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PIEPageVM* vm = [_source objectAtIndex:indexPath.row];
    CGFloat width;
    CGFloat height;
    width = (SCREEN_WIDTH) /2 - 20;
    height = vm.imageHeight/vm.imageWidth * width  + 70;
    height = MAX(150, height);
    height = MIN(SCREEN_HEIGHT/2, height);
    return CGSizeMake(width, height);
}
@end
