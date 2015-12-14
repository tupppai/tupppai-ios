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
#import "PIEProceedingManager.h"

#import "PIEProceedingToHelpTableViewCell.h"
#import "QBImagePickerController.h"
#import "PIEUploadVC.h"
#import "PIEFriendViewController.h"
#import "DDPageManager.h"
#import "PIEProceedingAskTableViewCell.h"
#import "PIECarouselViewController.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
#import "PIEProceedingShareView.h"
#import "PIEProceedingAskTableViewCell_NoGap.h"
//#import "UITableView+FDTemplateLayoutCell.h"

#define MyAskCellWidth (SCREEN_WIDTH - 20) / 2.0

/* Protocols */
@interface PIEProceedingViewController (UIScrollView)
<UIScrollViewDelegate>
@end

//@interface PIEProceedingViewController (UICollectionView)
//<UICollectionViewDataSource, UICollectionViewDelegate>
//@end
//
//@interface PIEProceedingViewController (PWRefreshBaseCollectionView)
//<PWRefreshBaseCollectionViewDelegate>
//@end
//
//@interface PIEProceedingViewController (CHTCollectionViewDelegateWaterfallLayout)
//<CHTCollectionViewDelegateWaterfallLayout>
//@end

@interface PIEProceedingViewController (PWRefreshBaseTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEProceedingViewController (UITableView)
<UITableViewDelegate, UITableViewDataSource>
@end

@interface PIEProceedingViewController (QBImagePickerController)
<QBImagePickerControllerDelegate>
@end

@interface PIEProceedingViewController (PIEProceedingShareView)
<PIEProceedingShareViewDelegate>
@end

@interface PIEProceedingViewController (DZNEmptyDataSet)
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

/* Private variables */
@interface PIEProceedingViewController ()
@property (nonatomic, strong) PIEProceedingScrollView *sv;

@property (nonatomic, assign) BOOL isfirstLoadingAsk;
@property (nonatomic, assign) BOOL isfirstLoadingToHelp;
//@property (nonatomic, assign) BOOL isfirstLoadingDone;

@property (nonatomic, strong) NSMutableArray *sourceAsk;
@property (nonatomic, strong) NSMutableArray *sourceToHelp;
//@property (nonatomic, strong) NSMutableArray *sourceDone;

@property (nonatomic, assign) NSInteger currentIndex_MyAsk;
@property (nonatomic, assign) NSInteger currentIndex_ToHelp;
//@property (nonatomic, assign) NSInteger currentIndex_Done;

@property (nonatomic, assign)  long long timeStamp_myAsk;
@property (nonatomic, assign)  long long timeStamp_toHelp;
//@property (nonatomic, assign)  long long timeStamp_done;

@property (nonatomic, assign) BOOL canRefreshAskFooter;
@property (nonatomic, assign) BOOL canRefreshToHelpFooter;
//@property (nonatomic, assign) BOOL canRefreshDoneFooter;

@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) PIEPageVM* selectedVM;

@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;
@property (nonatomic, strong) PIEProceedingShareView *shareView;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureAsk;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureToHelp;

@end

@implementation PIEProceedingViewController

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configData];
    [self createNavBar];
    [self configSubviews];
    [self getSourceIfEmpty_ask];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"进入进行中"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"离开进行中"];
}

#pragma mark - Refreshing methods
- (void)getSourceIfEmpty_ask {
    if (_sourceAsk.count <= 0 || _isfirstLoadingAsk) {
        [self.sv.askTableView.mj_header beginRefreshing];
    }
}
- (void)getSourceIfEmpty_toHelp {
    if (_sourceToHelp.count <= 0 || _isfirstLoadingToHelp) {
        [self.sv.toHelpTableView.mj_header beginRefreshing];
    }
}
//- (void)getSourceIfEmpty_done {
//    if (_sourceDone.count <= 0 || _isfirstLoadingDone) {
//        [self.sv.doneCollectionView.mj_header beginRefreshing];
//    }
//}
#pragma mark - init methods

- (void)configData {
    _canRefreshAskFooter    = YES;
    _canRefreshToHelpFooter = YES;
//    _canRefreshDoneFooter = YES;

    _isfirstLoadingAsk      = YES;
    _isfirstLoadingToHelp   = YES;
//    _isfirstLoadingDone = YES;


    _currentIndex_MyAsk     = 1;
    _currentIndex_ToHelp    = 1;
//    _currentIndex_Done = 1;

    _sourceAsk              = [NSMutableArray new];
    _sourceToHelp           = [NSMutableArray new];
//    _sourceDone = [NSMutableArray new];
}
- (void)configSubviews {
    self.view = self.sv;
    [self configAskCollectionView];
    [self configToHelpTableView];
//    [self configDoneCollectionView];
    [self setupGestures];
}
- (void)configAskCollectionView {
    _sv.askTableView.dataSource           = self;
    _sv.askTableView.delegate             = self;
    _sv.askTableView.psDelegate           = self;
    _sv.askTableView.emptyDataSetDelegate = self;
    _sv.askTableView.emptyDataSetSource   = self;
    UINib* nib = [UINib nibWithNibName:@"PIEProceedingAskTableViewCell" bundle:nil];
    [_sv.askTableView registerNib:nib forCellReuseIdentifier:@"PIEProceedingAskTableViewCell"];
    
    UINib* nib2 = [UINib nibWithNibName:@"PIEProceedingAskTableViewCell_NoGap" bundle:nil];
    [_sv.askTableView registerNib:nib2 forCellReuseIdentifier:@"PIEProceedingAskTableViewCell_NoGap"];

}
//- (void)configDoneCollectionView {
//    _sv.doneCollectionView.dataSource = self;
//    _sv.doneCollectionView.delegate = self;
//    _sv.doneCollectionView.psDelegate = self;
//    _sv.doneCollectionView.emptyDataSetSource = self;
//    _sv.doneCollectionView.emptyDataSetDelegate = self;
//    UINib* nib = [UINib nibWithNibName:@"PIEDoneCollectionViewCell" bundle:nil];
//    [_sv.doneCollectionView registerNib:nib forCellWithReuseIdentifier:@"PIEDoneCollectionViewCell"];
//}
- (void)configToHelpTableView {
    _sv.toHelpTableView.dataSource           = self;
    _sv.toHelpTableView.delegate             = self;
    _sv.toHelpTableView.psDelegate           = self;
    _sv.toHelpTableView.emptyDataSetDelegate = self;
    _sv.toHelpTableView.emptyDataSetSource   = self;
    _sv.toHelpTableView.estimatedRowHeight   = 145;
    _sv.toHelpTableView.rowHeight            = UITableViewAutomaticDimension;
    _sv.toHelpTableView.separatorStyle       = UITableViewCellSeparatorStyleSingleLine;
    _sv.toHelpTableView.separatorInset       = UIEdgeInsetsMake(0, 132, 0, 0);
    _sv.toHelpTableView.separatorColor       = [UIColor colorWithHex:0xd8d8d8 andAlpha:1.0];

    UINib* nib = [UINib nibWithNibName:@"PIEProceedingToHelpTableViewCell" bundle:nil];
    [_sv.toHelpTableView registerNib:nib forCellReuseIdentifier:@"PIEProceedingToHelpTableViewCell"];
}

#pragma mark - Gesture events
- (void)setupGestures {
    UITapGestureRecognizer* tapToHelpTableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHelpTableViewGesture:)];
    [_sv.toHelpTableView addGestureRecognizer:tapToHelpTableViewGesture];

    _longPressGestureAsk = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnAsk:)];
    _longPressGestureToHelp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnToHelp:)];
    [_sv.toHelpTableView addGestureRecognizer:_longPressGestureToHelp];
    [_sv.askTableView addGestureRecognizer:_longPressGestureAsk];

    
}
- (void)longPressOnAsk:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_sv.askTableView];
    NSIndexPath *indexPath = [_sv.askTableView indexPathForRowAtPoint:location];
    _selectedIndexPath = indexPath;
    _selectedVM = [_sourceAsk objectAtIndex:indexPath.row];
    if (indexPath) {
        //点击图片
        [self showShareViewWithToHideDeleteButton:YES];
    }
}
- (void)longPressOnToHelp:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_sv.toHelpTableView];
    NSIndexPath *indexPath = [_sv.toHelpTableView indexPathForRowAtPoint:location];
    _selectedIndexPath = indexPath;
    _selectedVM = [_sourceToHelp objectAtIndex:indexPath.row];
    if (indexPath) {
        //点击图片
        [self showShareViewWithToHideDeleteButton:NO];
    }
}
- (void)tapToHelpTableViewGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_sv.toHelpTableView];
    NSIndexPath *indexPath = [_sv.toHelpTableView indexPathForRowAtPoint:location];
    _selectedIndexPath = indexPath;
    PIEPageVM* vm = [_sourceToHelp objectAtIndex:indexPath.row];
    if (indexPath) {
        PIEProceedingToHelpTableViewCell *cell = (PIEProceedingToHelpTableViewCell *)[_sv.toHelpTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.uploadView.frame, p)) {
            [self presentViewController:self.QBImagePickerController animated:YES completion:nil];
        }
        else if (CGRectContainsPoint(cell.downloadView.frame, p)) {
            UIImageWriteToSavedPhotosAlbum(cell.theImageView.image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
//        else if (CGRectContainsPoint(cell.deleteView.frame, p)) {
//            [self deleteOneToHelp:indexPath ID:vm.ID];
//        }
        else if (CGRectContainsPoint(cell.avatarView.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            opvc.pageVM =  vm;
            [self.navigationController pushViewController:opvc animated:YES];
        }
        else if (CGRectContainsPoint(cell.nameLabel.frame, p)) {
            PIEFriendViewController *opvc = [PIEFriendViewController new];
            opvc.pageVM =  vm;
            [self.navigationController pushViewController:opvc animated:YES];
        }
        else if (CGRectContainsPoint(cell.theImageView.frame, p)) {
            PIECarouselViewController* vc = [PIECarouselViewController new];
            vc.pageVM = vm;
            DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
            [nav pushViewController:vc animated:YES ];
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

#pragma mark - toHelp tableView之内的点击事件
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    if(error != NULL){
        [Hud customText:@"下载出错" inView:[AppDelegate APP].window];
    } else {
        [Hud customText:@"下载成功\n我猜你会用美图秀秀来P?" inView:[AppDelegate APP].window];
    }
}



#pragma mark - refresh delegate

//-(void)didPullDownCollectionView:(UICollectionView *)collectionView {
//        if (collectionView == _sv.doneCollectionView) {
//        [self getRemoteSourceDone];
//    }
//}
//
//-(void)didPullUpCollectionViewBottom:(UICollectionView *)collectionView {
//    if (collectionView == _sv.doneCollectionView) {
//        if (_canRefreshDoneFooter) {
//            [self getMoreRemoteSourceDone];
//        } else {
//            [_sv.doneCollectionView.mj_footer endRefreshing];
//        }
//    }
//}


-(void)didPullRefreshDown:(UITableView *)tableView {
    if (tableView == _sv.askTableView) {
        [self getRemoteSourceMyAsk];
    } else if (tableView == _sv.toHelpTableView) {
        [self getRemoteSourceToHelp];
    }
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (tableView == _sv.askTableView) {
        if (_canRefreshAskFooter) {
            [self getMoreRemoteSourceMyAsk];
        } else {
            [_sv.askTableView.mj_footer endRefreshing];
        }
    } else if (tableView == _sv.toHelpTableView) {
        if (_canRefreshToHelpFooter) {
            [self getMoreRemoteSourceToHelp];
        } else {
            [_sv.toHelpTableView.mj_footer endRefreshing];
        }
    }

}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _sv) {
        int currentPage = (scrollView.contentOffset.x + CGWidth(scrollView.frame) * 0.1) / CGWidth(scrollView.frame);
        if (currentPage == 0) {
            [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
            _sv.type = PIEProceedingTypeAsk;
            [self getSourceIfEmpty_ask];
        }
        else if (currentPage == 1) {
            [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
            _sv.type = PIEProceedingTypeToHelp;
            [self getSourceIfEmpty_toHelp];
        }
//        else if (currentPage == 2) {
//            [_segmentedControl setSelectedSegmentIndex:2 animated:YES];
//            _sv.type = PIEProceedingTypeDone;
//            [self getSourceIfEmpty_done];
//
//        }
    }
}

#pragma mark - <QBImagePickerControllerDelegate>
-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    NSMutableArray* array = [NSMutableArray new];
    for (ALAsset* asset in assets) {
        [array addObject:asset];
    }
    PIEUploadVC* vc = [PIEUploadVC new];
    vc.assetsArray = assets;
    vc.hideSecondView = YES;
    vc.type = PIEUploadTypeReply;
    PIEPageVM* vm = [_sourceToHelp objectAtIndex:_selectedIndexPath.row];
    vc.askIDToReply = vm.askID;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(vm.askID) forKey:@"AskIDToReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
}


#pragma mark - segue methods

//跳到求p页面
- (void)navToToHelp {
    [_sv toggleWithType:PIEProceedingTypeToHelp];
    [_segmentedControl setSelectedSegmentIndex:1 animated:YES];
}

#pragma mark - UI components setup
- (void)createNavBar {
    WS(ws);
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"我的求P",@"我的帮P"]];
    _segmentedControl.frame = CGRectMake(0, 120, SCREEN_WIDTH-40, 45);
    _segmentedControl.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor colorWithHex:0x000000 andAlpha:0.6], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -1, 0);
    _segmentedControl.selectionIndicatorColor = [UIColor yellowColor];
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        if (index == 0) {
            [ws.sv toggleWithType:PIEProceedingTypeAsk];
            [ws getSourceIfEmpty_ask];
        } else if (index == 1) {
            [ws.sv toggleWithType:PIEProceedingTypeToHelp];
            [ws getSourceIfEmpty_toHelp];
        }
//        else if (index == 2) {
////            [ws.sv toggleWithType:PIEProceedingTypeDone];
////            [ws getSourceIfEmpty_done];
//            // do nothing now.
//        }
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

- (void)showShareViewWithToHideDeleteButton:(BOOL)hide{
    self.shareView.hideDeleteButton = hide;
    [self.shareView show];
    
}
-(PIEProceedingShareView *)shareView {
    if (!_shareView) {
        _shareView = [PIEProceedingShareView new];
        _shareView.delegate = self;
    }
    return _shareView;
}


#pragma mark - 
#pragma mark - UITableView Datasource and delegate
#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _sv.askTableView) {
        return _sourceAsk.count;
    }
    else if (tableView == _sv.toHelpTableView) {
        return _sourceToHelp.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sv.askTableView) {
        if (indexPath.row == 0) {
            PIEProceedingAskTableViewCell_NoGap *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEProceedingAskTableViewCell_NoGap"];
            [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
            return cell;
        } else {
            PIEProceedingAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEProceedingAskTableViewCell"];
            [cell injectSource:[_sourceAsk objectAtIndex:indexPath.row]];
            return cell;
        }
    }
    else if (tableView == _sv.toHelpTableView) {
        PIEProceedingToHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEProceedingToHelpTableViewCell"];
        [cell injectSource:[_sourceToHelp objectAtIndex:indexPath.row]];
        return cell;
    }
        return nil;
    
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _sv.askTableView) {
        if (indexPath.row == 0) {
            return 180-15;
        } else {
            return 175;
        }
    } else {
        return UITableViewAutomaticDimension;
    }
//    else if (tableView == _sv.toHelpTableView) {
////        return [tableView fd_heightForCellWithIdentifier:@"PIEProceedingToHelpTableViewCell"  cacheByIndexPath:indexPath configuration:^(PIEProceedingToHelpTableViewCell *cell) {
////            [cell injectSource:[_sourceToHelp objectAtIndex:indexPath.row]];
////        }];
////        PIEProceedingToHelpTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////        UITextView* textV = [UITextView new];
////        textV.text = ((PIEPageVM*)[_sourceToHelp objectAtIndex:indexPath.row]).content;
////        CGSize size = [textV sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)];
////        NSLog(@"_contentTextView width %f",cell.contentTextView.frame.size.width);
////        NSLog(@"_contentTextView height %f",size.height);
////        return size.height + 72;
//        
//    }
//    else {
//        return 0;
//    }
}

//#pragma mark - <UICollectionViewDataSource>
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (collectionView == _sv.doneCollectionView) {
//        return _sourceDone.count;
//    }
//    return 0;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (collectionView == _sv.doneCollectionView) {
//        PIEDoneCollectionViewCell *cell =
//        (PIEDoneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PIEDoneCollectionViewCell"
//                                                                               forIndexPath:indexPath];
//        [cell injectSauce:[_sourceDone objectAtIndex:indexPath.row]];
//        return cell;
//    }
//    return nil;
//}
//
//#pragma mark - <UICollectionViewDelegate>
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    PIECarouselViewController* vc = [PIECarouselViewController new];
//    vc.pageVM = [_sourceDone objectAtIndex:indexPath.row];
//    DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
//    [nav pushViewController:vc animated:YES ];
//}


//#pragma mark - <CHTCollectionViewDelegateWaterfallLayout>
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    PIEPageVM* vm = [_sourceDone objectAtIndex:indexPath.row];
//    CGFloat width;
//    CGFloat height;
//    width = (SCREEN_WIDTH) /2 - 20;
//    height = vm.imageHeight/vm.imageWidth * width;
//    height = MAX(150, height);
//    height = MIN(SCREEN_HEIGHT/2, height);
//    return CGSizeMake(width, height);
//}

#pragma mark - getRemoteSourceMyAsk

- (void)getRemoteSourceMyAsk {
    WS(ws);
    [ws.sv.askTableView.mj_footer endRefreshing];
    _currentIndex_MyAsk = 1;
    _timeStamp_myAsk = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH/2) forKey:@"width"];
    [param setObject:@(_timeStamp_myAsk) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getAskWithReplies:param withBlock:^(NSArray *returnArray) {
        ws.isfirstLoadingAsk = NO;
        if (returnArray.count == 0) {
            _canRefreshAskFooter = NO;
        } else {
            _canRefreshAskFooter = YES;
            [ws.sourceAsk removeAllObjects];
            [ws.sourceAsk addObjectsFromArray:returnArray];
        }
        [ws.sv.askTableView reloadData];
        [ws.sv.askTableView.mj_header endRefreshing];
    }];
}

- (void)getMoreRemoteSourceMyAsk {
    WS(ws);
    [ws.sv.askTableView.mj_header endRefreshing];
    _currentIndex_MyAsk++;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex_MyAsk) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp_myAsk) forKey:@"last_updated"];
    [param setObject:@(15) forKey:@"size"];
    [DDPageManager getAskWithReplies:param withBlock:^(NSArray *returnArray) {
        if (returnArray.count == 0) {
            _canRefreshAskFooter = NO;
        } else {
            _canRefreshAskFooter = YES;
            [ws.sourceAsk addObjectsFromArray:returnArray];
        }
        [ws.sv.askTableView reloadData];
        [ws.sv.askTableView.mj_footer endRefreshing];
    }];

}

#pragma mark - getRemoteSourceToHelp

- (void)getRemoteSourceToHelp {
    WS(ws);
    [_sv.toHelpTableView.mj_footer endRefreshing];
    _currentIndex_ToHelp = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp_toHelp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp_toHelp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    [PIEProceedingManager getMyToHelp:param withBlock:^(NSMutableArray *resultArray) {
        ws.isfirstLoadingToHelp = NO;
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sourceToHelp removeAllObjects];
            [ws.sourceToHelp addObjectsFromArray:sourceAgent];
        }
        [ws.sv.toHelpTableView reloadData];
        [ws.sv.toHelpTableView.mj_header endRefreshing];
    }];
}

- (void)getMoreRemoteSourceToHelp {
    WS(ws);
    _currentIndex_ToHelp ++;
    [_sv.toHelpTableView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex_ToHelp) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(_timeStamp_toHelp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    [PIEProceedingManager getMyToHelp:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sourceToHelp addObjectsFromArray:sourceAgent];
        }
        [ws.sv.toHelpTableView reloadData];
        [ws.sv.toHelpTableView.mj_footer endRefreshing];
    }];
}

//- (void)getRemoteSourceDone {
//    WS(ws);
//    [ws.sv.doneCollectionView.mj_footer endRefreshing];
//    _currentIndex_Done = 1;
//    _timeStamp_done = [[NSDate date] timeIntervalSince1970];
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@(1) forKey:@"page"];
////    [param setObject:@(SCREEN_WIDTH/2) forKey:@"width"];
//    [param setObject:@(_timeStamp_done) forKey:@"last_updated"];
//    [param setObject:@(15) forKey:@"size"];
//    
//    [PIEProceedingManager getMyDone:param withBlock:^(NSMutableArray *resultArray) {
//        ws.isfirstLoadingDone = NO;
//        if (resultArray.count == 0) {
//            _canRefreshDoneFooter = NO;
//        } else {
//            _canRefreshDoneFooter = YES;
//            NSMutableArray* sourceAgent = [NSMutableArray new];
//            for (PIEPageEntity *homeImage in resultArray) {
//                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:homeImage];
//                [sourceAgent addObject:vm];
//            }
//            
//            [ws.sourceDone removeAllObjects];
//            [ws.sourceDone addObjectsFromArray:sourceAgent];
//        }
//        [ws.sv.doneCollectionView.mj_header endRefreshing];
//        [ws.sv.doneCollectionView reloadData];
//
//    }];
//}
//- (void)getMoreRemoteSourceDone {
//    WS(ws);
//    [ws.sv.doneCollectionView.mj_header endRefreshing];
//    _currentIndex_Done++;
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@(_currentIndex_Done) forKey:@"page"];
//    [param setObject:@(SCREEN_WIDTH/2) forKey:@"width"];
//    [param setObject:@(_timeStamp_done) forKey:@"last_updated"];
//    [param setObject:@(15) forKey:@"size"];
//    
//    [PIEProceedingManager getMyDone:param withBlock:^(NSMutableArray *resultArray) {
//        if (resultArray.count == 0) {
//            _canRefreshDoneFooter = NO;
//        } else {
//            _canRefreshDoneFooter = YES;
//            NSMutableArray* sourceAgent = [NSMutableArray new];
//            for (PIEPageEntity *homeImage in resultArray) {
//                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:homeImage];
//                [sourceAgent addObject:vm];
//            }
//            [ws.sourceDone addObjectsFromArray:sourceAgent];
//        }
//        [ws.sv.doneCollectionView.mj_footer endRefreshing];
//        [ws.sv.doneCollectionView reloadData];
//
//    }];
//}
#pragma mark - ATOMShareViewDelegate
//sina
-(void)tapShare1 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeSinaWeibo block:nil];
}
//qqzone
-(void)tapShare2 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQZone  block:nil];
}
//wechat moments
-(void)tapShare3 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatMoments block:nil];
}
//wechat friends
-(void)tapShare4 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeWechatFriends  block:nil];
}
-(void)tapShare5 {
    [self.shareView dismiss];
    [DDShareManager postSocialShare2:_selectedVM withSocialShareType:ATOMShareTypeQQFriends  block:nil];
    
}
-(void)tapShare6 {
    [DDShareManager copy:_selectedVM];
}
-(void)tapShare7 {
    [self.shareView dismiss];
    if (_sv.type == PIEProceedingTypeToHelp) {
        PIEPageVM* vm = [_sourceToHelp objectAtIndex:_selectedIndexPath.row];
        [self deleteOneToHelp:_selectedIndexPath ID:vm.ID];
    }
}

-(void)tapShareCancel {
    [self.shareView dismiss];
}

#pragma mark - <DZNEmptyDataSetSource & delegate>
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text ;
    if (scrollView == _sv.askTableView) {
       text = @"还没发布求P,赶快发布召唤大神";
    } else if (scrollView == _sv.toHelpTableView) {
        text = @"还没认领帮P?就这样少了个炫（装）技（B）的机会咯？";
    }
//    else if (scrollView == _sv.doneCollectionView) {
//        text = @"还没内容呀，加把劲啊啊啊马上来上传";
//    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    if (scrollView == _sv.askTableView) {
        return !_isfirstLoadingAsk;
    } else if (scrollView == _sv.toHelpTableView) {
        return !_isfirstLoadingToHelp;
    }
//    } else if (scrollView == _sv.doneCollectionView) {
//        return !_isfirstLoadingDone;
//    }
    return NO;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
