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
@interface PIEReplyCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CHTCollectionViewDelegateWaterfallLayout,PWRefreshBaseCollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *source;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL canRefreshFoot;
@property (nonatomic, strong) DDPageVM* currentVM;
@property (nonatomic, strong) PIERefreshCollectionView* collectionView;
@end

@implementation PIEReplyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = self.collectionView;
    _source = [NSMutableArray array];
    _canRefreshFoot = YES;
    [self getRemoteSource];
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
            NSMutableArray* arrayAgent = [NSMutableArray new];
            for (PIEPageEntity *entity in replyArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [arrayAgent addObject:vm];
            }
            [_source removeAllObjects];
            [_source addObjectsFromArray:arrayAgent];
            [self.collectionView reloadData];
            _canRefreshFoot = YES;
        }
        else {
            _canRefreshFoot = NO;
        }
        [self.collectionView.header endRefreshing];
    }];
}
- (void)getMoreRemoteSource {
    _currentPage ++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(SCREEN_WIDTH - 2 * kPadding15) forKey:@"width"];
    [param setObject:@(_currentPage) forKey:@"page"];
    [param setObject:@(15) forKey:@"size"];
    DDHotDetailManager *manager = [DDHotDetailManager new];
    [manager fetchAllReply:param ID:_pageVM.askID withBlock:^(NSMutableArray *askArray, NSMutableArray *replyArray) {
        for (PIEPageEntity *entity in replyArray) {
            if (replyArray.count>0) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:entity];
                [_source addObject:vm];
                [self.collectionView reloadData];
                _canRefreshFoot = YES;
            }
            else {
                _canRefreshFoot = NO;
            }
        }
        [self.collectionView.footer endRefreshing];
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
    }
    return _collectionView;
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
            [_collectionView.footer endRefreshing];
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

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm;
    if (collectionView == _collectionView) {
        vm =   [_source objectAtIndex:indexPath.row];
    }
    CGFloat width;
    CGFloat height;
    
    width = (SCREEN_WIDTH - 20) / 2.0;
    height = vm.imageHeight + 46;
    if (height > (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3) {
        height = (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3;
    }
    return CGSizeMake(width, height);
}
@end
