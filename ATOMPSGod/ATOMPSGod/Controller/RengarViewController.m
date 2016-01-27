//
//  PIEUploadViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 1/27/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "RengarViewController.h"
#import "SZTextView.h"
#import "RengarPanelView.h"
#import "RengarBottomBar.h"
#import "RengarAssetCollectionViewCell.h"
#import "MMPlaceHolder.h"
@interface RengarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) SZTextView *textView;
@property (nonatomic,strong) RengarPanelView *panelView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) RengarBottomBar *bottomBar;

@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) NSMutableOrderedSet *assetOrderedSet;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) MASConstraint *panelViewTopMarginContraint;
@property (nonatomic, assign) CGFloat initialHeight;
@property (nonatomic, assign) CGFloat expandedHeight;

@end



@implementation RengarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupNavBar];
    [self setupViews];
    [self.view showPlaceHolderWithAllSubviews];
    
    PHFetchResult *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [assetCollections enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:obj options:options];
        [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.assetOrderedSet addObject:obj];
        }];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (_expandedHeight == 0) {
        _expandedHeight = self.textView.frame.size.height + _initialHeight - 60;
    }
}
-(void)setupData {
    _assetOrderedSet = [NSMutableOrderedSet orderedSet];
    _initialHeight = SCREEN_WIDTH*2.0/3.0;
}
- (void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
    if (self.assetCollection) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        
        [self.assetOrderedSet removeAllObjects];

        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];
        [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.assetOrderedSet addObject:obj];
        }];
        
    } else {
        [self.assetOrderedSet removeAllObjects];
    }
    
    [self.collectionView reloadData];
}

-(void)setupNavBar {
    UILabel *titleView = [UILabel new];
    titleView.text = @"上传作业";
    titleView.font = [UIFont lightTupaiFontOfSize:16];
    titleView.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    UIButton *barButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [barButton setTitle:@"发布" forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor colorWithHex:0x000000 andAlpha:0.6] forState:UIControlStateNormal];
    [barButton addTarget:self action:@selector(tapNavBarRightBarButton)
        forControlEvents:UIControlEventTouchUpInside];
    barButton.titleLabel.font = [UIFont lightTupaiFontOfSize:15];

    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithCustomView:barButton];

    self.navigationItem.rightBarButtonItem = barButtonItem;

}

-(void)setupViews {
    [self.view addSubview:self.textView];
    [self.view addSubview:self.panelView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBar];
    
    [self setupViewContraints];
}


-(void)setupViewContraints {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.and.trailing.equalTo(self.view);
    }];
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).with.offset(2);
        make.leading.and.trailing.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panelView.mas_bottom);
        make.leading.and.trailing.equalTo(self.view);
        self.panelViewTopMarginContraint = make.height.equalTo(@(self.initialHeight));
    }];
    [self.bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.equalTo(@60);
        make.leading.and.trailing.and.bottom.equalTo(self.view);
    }];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetOrderedSet.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Image
    
    RengarAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RengarAssetCollectionViewCell" forIndexPath:indexPath];

    
    PHAsset *asset = self.assetOrderedSet[indexPath.item];
    CGSize itemSize = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout itemSize];
    CGSize targetSize = CGSizeMake(itemSize.width*SCREEN_SCALE, itemSize.height*SCREEN_SCALE);
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                 targetSize:targetSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                      cell.imageView.image = result;
                              }];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndexPath == indexPath) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        _selectedIndexPath = nil;
        return;
    }
    _selectedIndexPath = indexPath;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat startContentOffsetY = scrollView.contentOffset.y;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat distance = ABS(startContentOffsetY - scrollView.contentOffset.y);
        if (distance < 100) {
            return ;
        }
        if (startContentOffsetY > scrollView.contentOffset.y  ) {
            [self scrollViewDidScrollDown];
        }
        else if (startContentOffsetY < scrollView.contentOffset.y)
        {
            [self scrollViewDidScrollUp];
        }
        
    });
}


- (void)scrollViewDidScrollUp {
    [self resignTextView];
    [self.panelViewTopMarginContraint setOffset:_expandedHeight];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (void)scrollViewDidScrollDown {
    [self resignTextView];
    [self.panelViewTopMarginContraint setOffset:_initialHeight];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];

}
-(void)tapNavBarRightBarButton {
    [self resignTextView];
}


- (void)resignTextView {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}
-(SZTextView *)textView {
    if (_textView == nil) {
        _textView = [SZTextView new];
        _textView.placeholder = @"请输入你的作业描述";
        _textView.placeholderTextColor = [UIColor colorWithHex:0x000000 andAlpha:0.3];
        _textView.font = [UIFont lightTupaiFontOfSize:15];
    }
    return _textView;
}
-(RengarPanelView *)panelView {
    if (_panelView == nil) {
        _panelView = [RengarPanelView new];
    }
    return _panelView;
}

-(UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setMinimumInteritemSpacing:1.0f];
        [layout setMinimumLineSpacing:3.0F];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/3.0 - 3, SCREEN_WIDTH/3.0 - 3);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"RengarAssetCollectionViewCell" bundle:NULL];
        [_collectionView registerNib:nib forCellWithReuseIdentifier:@"RengarAssetCollectionViewCell"];

        _collectionView.backgroundColor = [UIColor colorWithHex:0x4a4a4a andAlpha:1.0];
    }
    return _collectionView;
}

-(RengarBottomBar *)bottomBar {
    if (_bottomBar == nil) {
        _bottomBar = [RengarBottomBar new];
    }
    return _bottomBar;
}


@end
