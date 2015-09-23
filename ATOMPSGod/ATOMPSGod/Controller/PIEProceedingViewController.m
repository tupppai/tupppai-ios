//
//  PIEProceedingViewController.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingViewController.h"
#import "PIEProceedingScrollView.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PIEMyAskCollectionCell.h"
#import "PIEDoneCollectionViewCell.h"
#import "DDMyAskManager.h"
#import "DDMyProceedingManager.h"
#import "DDPageVM.h"
#import "PIEToHelpTableViewCell.h"
#import "QBImagePickerController.h"
#import "PIEUploadVC.h"
#import "ATOMOtherPersonViewController.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
#define MyAskCellWidth (SCREEN_WIDTH - 20) / 2.0

@interface PIEProceedingViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PWRefreshBaseCollectionViewDelegate,PWRefreshBaseTableViewDelegate,CHTCollectionViewDelegateWaterfallLayout,UITableViewDataSource,UITableViewDelegate,QBImagePickerControllerDelegate>

@property (nonatomic, strong) PIEProceedingScrollView *sv;

@property (nonatomic, strong) NSMutableArray *sourceAsk;
@property (nonatomic, strong) NSMutableArray *sourceToHelp;
@property (nonatomic, strong) NSMutableArray *sourceDone;

@property (nonatomic, assign) NSInteger currentIndex_MyAsk;
@property (nonatomic, assign) NSInteger currentIndex_ToHelp;
@property (nonatomic, assign) NSInteger currentIndex_Done;

@property (nonatomic, assign) BOOL canRefreshAskFooter;
@property (nonatomic, assign) BOOL canRefreshToHelpFooter;
@property (nonatomic, assign) BOOL canRefreshDoneFooter;

@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;

@end

@implementation PIEProceedingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self createNavBar];
    [self configSubviews];
    [self getRemoteSourceMyAsk];
    [self getRemoteSourceToHelp];
}

#pragma mark - init methods

- (void)configData {
    _canRefreshAskFooter = YES;
    _canRefreshToHelpFooter = YES;
    _canRefreshDoneFooter = YES;
    _currentIndex_MyAsk = 1;
    _currentIndex_ToHelp = 1;
    _currentIndex_Done = 1;
    
    _sourceAsk = [NSMutableArray new];
    _sourceToHelp = [NSMutableArray new];
    _sourceDone = [NSMutableArray new];
}
- (void)configSubviews {
    self.view = self.sv;
    [self configAskCollectionView];
    [self configToHelpTableView];
    [self configDoneCollectionView];
}
- (void)configAskCollectionView {
    _sv.askCollectionView.dataSource = self;
    _sv.askCollectionView.delegate = self;
    _sv.askCollectionView.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEMyAskCollectionCell" bundle:nil];
    [_sv.askCollectionView registerNib:nib forCellWithReuseIdentifier:@"PIEMyAskCollectionCell"];
}
- (void)configDoneCollectionView {
    _sv.doneCollectionView.dataSource = self;
    _sv.doneCollectionView.delegate = self;
    _sv.doneCollectionView.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEDoneCollectionViewCell" bundle:nil];
    [_sv.doneCollectionView registerNib:nib forCellWithReuseIdentifier:@"PIEDoneCollectionViewCell"];
}
- (void)configToHelpTableView {
    _sv.toHelpTableView.dataSource = self;
    _sv.toHelpTableView.delegate = self;
    _sv.toHelpTableView.psDelegate = self;
    UINib* nib = [UINib nibWithNibName:@"PIEToHelpTableViewCell" bundle:nil];
    [_sv.toHelpTableView registerNib:nib forCellReuseIdentifier:@"PIEToHelpTableViewCell"];
    UITapGestureRecognizer* tapToHelpTableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHelpTableViewGesture:)];
    [_sv.toHelpTableView addGestureRecognizer:tapToHelpTableViewGesture];
}
- (void)tapToHelpTableViewGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_sv.toHelpTableView];
    NSIndexPath *indexPath = [_sv.toHelpTableView indexPathForRowAtPoint:location];
    _selectedIndexPath = indexPath;
    DDPageVM* vm = [_sourceToHelp objectAtIndex:indexPath.row];
    if (indexPath) {
        PIEToHelpTableViewCell *cell = (PIEToHelpTableViewCell *)[_sv.toHelpTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.uploadView.frame, p)) {
            [self presentViewController:self.QBImagePickerController animated:YES completion:nil];
        }
        else if (CGRectContainsPoint(cell.downloadView.frame, p)) {
            UIImageWriteToSavedPhotosAlbum(cell.theImageView.image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        else if (CGRectContainsPoint(cell.deleteView.frame, p)) {
            [self deleteOneToHelp:indexPath ID:vm.ID];
        }
        else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = vm.userID;
            opvc.userName = vm.username;
            [self pushViewController:opvc animated:YES];
        }
        else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            opvc.userID = vm.userID;
            opvc.userName = vm.username;
            [self pushViewController:opvc animated:YES];
        }
        else if (CGRectContainsPoint(cell.theImageView.frame, p)) {
            
        }
    }
}
- (void)deleteOneToHelp :(NSIndexPath*)indexPath ID:(NSInteger)ID {
    NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:@(ID),@"id", nil];
    [DDService deleteProceeding:param withBlock:^(BOOL success) {
        if (success) {
            [Hud success:@"删除了一条帮p" inView:_sv.toHelpTableView];
        }
        [_sourceToHelp removeObjectAtIndex:indexPath.row];
        [_sv.toHelpTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Hud error:@"保存失败" inView:self.view];
    } else {
        [Hud success:@"已保存到相册" inView:self.view];
    }
}

#pragma mark - GetDataSource

- (void)getRemoteSourceToHelp {
    WS(ws);
    [_sv.toHelpTableView.footer endRefreshing];
    _currentIndex_ToHelp = 1;

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    [DDMyProceedingManager getMyProceeding:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
            [ws.sv.toHelpTableView.header endRefreshing];
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                DDPageVM *vm = [DDPageVM new];
                [vm setViewModelData:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sv.toHelpTableView.header endRefreshing];
            [ws.sourceToHelp removeAllObjects];
            [ws.sourceToHelp addObjectsFromArray:sourceAgent];
            [ws.sv.toHelpTableView reloadData];
        }
    }];
}

- (void)getMoreRemoteSourceToHelp {
    WS(ws);
    _currentIndex_ToHelp ++;
    [_sv.toHelpTableView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_currentIndex_ToHelp) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    [DDMyProceedingManager getMyProceeding:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
            [ws.sv.toHelpTableView.footer endRefreshing];
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                DDPageVM *vm = [DDPageVM new];
                [vm setViewModelData:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sv.toHelpTableView.footer endRefreshing];
            [ws.sourceToHelp addObjectsFromArray:sourceAgent];
            [ws.sv.toHelpTableView reloadData];
        }
    }];
}

#pragma mark - refresh delegate

-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
    if (collectionView == _sv.askCollectionView) {
        [self getRemoteSourceMyAsk];
    } else if (collectionView == _sv.doneCollectionView) {
        //to do!!
        //        [self getRemoteSourceMyAsk];
    }
}
-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
    if (collectionView == _sv.askCollectionView) {
        if (_canRefreshAskFooter) {
            [self getMoreRemoteSourceMyAsk];
        } else {
            [_sv.askCollectionView.footer endRefreshing];
        }
    } else if (collectionView == _sv.doneCollectionView) {
        if (_canRefreshDoneFooter) {
        } else {
            [_sv.doneCollectionView.footer endRefreshing];
        }
    }
}
-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSourceToHelp];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshToHelpFooter) {
        [self getMoreRemoteSourceToHelp];
    } else {
        [_sv.toHelpTableView.footer endRefreshing];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _sv) {
        int currentPage = (scrollView.contentOffset.x + CGWidth(scrollView.frame) * 0.1) / CGWidth(scrollView.frame);
        if (currentPage == 0) {
            [_sv toggleWithType:PIEProceedingTypeAsk];
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
        }
        else if (currentPage == 1) {
            [_sv toggleWithType:PIEProceedingTypeToHelp];
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
        }
        else if (currentPage == 2) {
            [_sv toggleWithType:PIEProceedingTypeDone];
            [_segmentedControl setSelectedSegmentIndex:2 animated:YES];
        }
    }
}


-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    
    NSMutableArray* array = [NSMutableArray new];
    for (ALAsset* asset in assets) {
        [array addObject:asset];
    }
    PIEUploadVC* vc = [PIEUploadVC new];
    vc.assetsArray = assets;
    vc.hideSecondView = YES;
    vc.type = PIEUploadTypeReply;
    DDPageVM* vm = [_sourceToHelp objectAtIndex:_selectedIndexPath.row];
    vc.askIDToReply = vm.ID;
    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
}




//跳到求p页面
- (void)navToToHelp {
    [_sv toggleWithType:PIEProceedingTypeToHelp];
    [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
}

- (void)createNavBar {
    WS(ws);
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"求P",@"帮P",@"已完成"]];
    _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH-100, 45);
    _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor darkGrayColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -5, 0);
    _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [ws.sv toggleWithType:PIEProceedingTypeAsk];
        } else if (index == 1) {
            [ws.sv toggleWithType:PIEProceedingTypeToHelp];
        } else if (index == 2) {
            [ws.sv toggleWithType:PIEProceedingTypeDone];
        }
    }];
    
    _segmentedControl.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = _segmentedControl;
}

#pragma mark - Getters and Setters

-(PIEProceedingScrollView*)sv {
    if (!_sv) {
        _sv = [PIEProceedingScrollView new];
        _sv.delegate =self;
    }
    return _sv;
}

- (QBImagePickerController* )QBImagePickerController {
    if (!_QBImagePickerController) {
        _QBImagePickerController = [QBImagePickerController new];
        _QBImagePickerController.delegate = self;
        _QBImagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        _QBImagePickerController.allowsMultipleSelection = YES;
        _QBImagePickerController.showsNumberOfSelectedAssets = YES;
        _QBImagePickerController.minimumNumberOfSelection = 1;
        _QBImagePickerController.maximumNumberOfSelection = 1;
    }
    return _QBImagePickerController;
}



#pragma mark - UITableView Datasource and delegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceToHelp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIEToHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEToHelpTableViewCell"];
    if (!cell) {
        cell = [[PIEToHelpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PIEToHelpTableViewCell"];
    }
    [cell injectSource:[_sourceToHelp objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _sv.askCollectionView) {
        return _sourceAsk.count;
    } else if (collectionView == _sv.doneCollectionView) {
        return _sourceDone.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _sv.askCollectionView) {
        PIEMyAskCollectionCell *cell =
        (PIEMyAskCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIEMyAskCollectionCell"
                                                                            forIndexPath:indexPath];
        [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
        return cell;
    } else if (collectionView == _sv.doneCollectionView) {
        PIEDoneCollectionViewCell *cell =
        (PIEDoneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIEDoneCollectionViewCell"
                                                                               forIndexPath:indexPath];
        [cell injectSauce:[_sourceDone objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDPageVM* vm;
    if (collectionView == _sv.askCollectionView) {
        vm =   [_sourceAsk objectAtIndex:indexPath.row];
    } else if (collectionView == _sv.doneCollectionView) {
        vm =   [_sourceDone objectAtIndex:indexPath.row];
    }
    
    CGFloat width;
    CGFloat height;
    
    width = MyAskCellWidth;
    height = vm.imageHeight + 46;
    if (height > (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3) {
        height = (SCREEN_HEIGHT-NAV_HEIGHT-TAB_HEIGHT)/1.3;
    }
    return CGSizeMake(width, height);}

#pragma mark - GetDataSource

- (void)getRemoteSourceMyAsk {
    WS(ws);
    [ws.sv.askCollectionView.footer endRefreshing];
    _currentIndex_MyAsk = 1;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(MyAskCellWidth) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    
    [DDMyAskManager getMyAsk:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshAskFooter = NO;
            [ws.sv.askCollectionView.header endRefreshing];
        } else {
            _canRefreshAskFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                DDPageVM *vm = [DDPageVM new];
                [vm setViewModelData:homeImage];
                [sourceAgent addObject:vm];
            }
            
            [ws.sv.askCollectionView.header endRefreshing];
            [ws.sourceAsk removeAllObjects];
            [ws.sourceAsk addObjectsFromArray:sourceAgent];
            [ws.sv.askCollectionView reloadData];
        }
    }];
}

- (void)getMoreRemoteSourceMyAsk {
    WS(ws);
    [ws.sv.askCollectionView.header endRefreshing];
    _currentIndex_MyAsk++;
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex_MyAsk) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDMyAskManager getMyAsk:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshAskFooter = NO;
            [ws.sv.askCollectionView.footer endRefreshing];
        } else {
            _canRefreshAskFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                DDPageVM *vm = [DDPageVM new];
                [vm setViewModelData:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sourceAsk addObjectsFromArray:sourceAgent];
            [ws.sv.askCollectionView reloadData];
            [ws.sv.askCollectionView.footer endRefreshing];
        }
    }];
}
@end
