//
//  PIEProceedingToHelpViewController.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 12/23/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEProceedingToHelpViewController.h"
#import "PIERefreshTableView.h"
#import "QBImagePickerController.h"
#import "PIEProceedingShareView.h"
#import "PIEProceedingToHelpTableViewCell.h"
#import "PIEFriendViewController.h"
#import "PIECommentViewController.h"
#import "DDNavigationController.h"
#import "PIECarouselViewController2.h"
#import "AppDelegate.h"
#import "PIEUploadVC.h"
#import "PIEProceedingManager.h"

/* Variables */
@interface PIEProceedingToHelpViewController ()

@property (nonatomic, strong) PIERefreshTableView *toHelpTableView;

@property (nonatomic, assign) BOOL isfirstLoadingToHelp;

@property (nonatomic, strong) NSMutableArray<PIEPageVM *> *sourceToHelp;

@property (nonatomic, assign) NSInteger currentIndex_ToHelp;

@property (nonatomic, assign)  long long timeStamp_toHelp;

@property (nonatomic, assign) BOOL canRefreshToHelpFooter;

@property (nonatomic, strong) NSIndexPath* selectedIndexPath_toHelp;

@property (nonatomic, strong) PIEPageVM* selectedVM;

@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;

@property (nonatomic, strong) PIEProceedingShareView *shareView;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureToHelp;

@end


/* Protocols */
@interface PIEProceedingToHelpViewController (TableView)
<UITableViewDataSource, UITableViewDelegate>
@end

@interface PIEProceedingToHelpViewController (RefreshTableView)
<PWRefreshBaseTableViewDelegate>
@end

@interface PIEProceedingToHelpViewController (DZNEmptyDataSet)
<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@end

@interface PIEProceedingToHelpViewController (QBImagePickerController)
<QBImagePickerControllerDelegate>
@end

@interface PIEProceedingToHelpViewController (ProceedingShareView)
<PIEProceedingShareViewDelegate>
@end

@implementation PIEProceedingToHelpViewController

static NSString *PIEProceedingToHelpTableViewCellIdentifier =
@"PIEProceedingToHelpTableViewCell";

#pragma mark - UI life cycles
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    
    [self configToHelpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init methods
- (void)configData {
    _canRefreshToHelpFooter = YES;
    
    _isfirstLoadingToHelp   = YES;
    
    _currentIndex_ToHelp    = 1;
    
    _sourceToHelp           = [NSMutableArray<PIEPageVM *> new];
}

- (void)configToHelpTableView {
    
    _toHelpTableView = [[PIERefreshTableView alloc] init];

    _toHelpTableView.dataSource           = self;
    _toHelpTableView.delegate             = self;
    _toHelpTableView.psDelegate           = self;
    _toHelpTableView.emptyDataSetDelegate = self;
    _toHelpTableView.emptyDataSetSource   = self;
    _toHelpTableView.estimatedRowHeight   = 145;
    _toHelpTableView.rowHeight            = UITableViewAutomaticDimension;
    _toHelpTableView.separatorStyle       = UITableViewCellSeparatorStyleSingleLine;
    _toHelpTableView.separatorInset       = UIEdgeInsetsMake(0, 132, 0, 0);
    _toHelpTableView.separatorColor       = [UIColor colorWithHex:0xd8d8d8 andAlpha:1.0];
    
    UINib* nib = [UINib nibWithNibName:@"PIEProceedingToHelpTableViewCell" bundle:nil];
    [_toHelpTableView registerNib:nib forCellReuseIdentifier:PIEProceedingToHelpTableViewCellIdentifier];
    
    
    [self.view addSubview:_toHelpTableView];
    [_toHelpTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Gesture events
- (void)setupGestures {
    UITapGestureRecognizer* tapToHelpTableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHelpTableViewGesture:)];
    [_toHelpTableView addGestureRecognizer:tapToHelpTableViewGesture];
    
    
    _longPressGestureToHelp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressOnToHelp:)];
    [_toHelpTableView addGestureRecognizer:_longPressGestureToHelp];
    
}


- (void)longPressOnToHelp:(UILongPressGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_toHelpTableView];
    NSIndexPath *indexPath = [_toHelpTableView indexPathForRowAtPoint:location];
    _selectedIndexPath_toHelp = indexPath;
    _selectedVM = [_sourceToHelp objectAtIndex:indexPath.row];
    if (indexPath) {
        //点击图片
        [self showShareViewWithToHideDeleteButton:NO];
    }
}

- (void)tapToHelpTableViewGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_toHelpTableView];
    NSIndexPath *indexPath = [_toHelpTableView indexPathForRowAtPoint:location];
    _selectedIndexPath_toHelp = indexPath;
    PIEPageVM* vm = [_sourceToHelp objectAtIndex:indexPath.row];
    if (indexPath) {
        PIEProceedingToHelpTableViewCell *cell = (PIEProceedingToHelpTableViewCell *)
        [_toHelpTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.uploadView.frame, p)) {
            self.QBImagePickerController = nil;
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
            if ([vm.replyCount integerValue]<=0) {
                PIECommentViewController *vc_comment = [PIECommentViewController new];
                vc_comment.vm = vm;
                DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
                DDNavigationController* nav2 = [[DDNavigationController alloc]initWithRootViewController:vc_comment];
                [nav presentViewController:nav2 animated:NO completion:nil];
            } else {
                PIECarouselViewController2* vc = [PIECarouselViewController2 new];
                vc.pageVM = vm;
                DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
                [nav presentViewController:vc animated:YES completion:nil];
            }
        }
    }
}
- (void)deleteOneToHelp :(NSIndexPath*)indexPath ID:(NSInteger)ID {
    NSDictionary* param = [[NSDictionary alloc]initWithObjectsAndKeys:@(ID),@"id", nil];
    [DDService deleteProceeding:param withBlock:^(BOOL success) {
        if (success) {
            [Hud success:@"删除了一条帮p" inView:_toHelpTableView];
        }
        [_sourceToHelp removeObjectAtIndex:indexPath.row];
        [_toHelpTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark - <PWRefreshBaseTableViewDelegate>
-(void)didPullRefreshDown:(UITableView *)tableView {
    
    [self getRemoteSourceToHelp];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    
    if (_canRefreshToHelpFooter) {
        [self getMoreRemoteSourceToHelp];
    } else {
        [_toHelpTableView.mj_footer endRefreshingWithNoMoreData];
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
    PIEPageVM* vm = [_sourceToHelp objectAtIndex:_selectedIndexPath_toHelp.row];
    vc.askIDToReply = vm.askID;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(vm.askID) forKey:@"AskIDToReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceToHelp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PIEProceedingToHelpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PIEProceedingToHelpTableViewCellIdentifier];
    [cell injectSource:[_sourceToHelp objectAtIndex:indexPath.row]];
    return cell;
   
}


#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - Fetch remote data
- (void)getRemoteSourceToHelp {
    WS(ws);
    [_toHelpTableView.mj_footer endRefreshing];
    _currentIndex_ToHelp = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _timeStamp_toHelp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
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
        [ws.toHelpTableView reloadData];
        [ws.toHelpTableView.mj_header endRefreshing];
    }];
}

- (void)getMoreRemoteSourceToHelp {
    WS(ws);
    _currentIndex_ToHelp ++;
    [_toHelpTableView.mj_header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(_currentIndex_ToHelp) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
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
        [ws.toHelpTableView reloadData];
        [ws.toHelpTableView.mj_footer endRefreshing];
    }];
}


#pragma mark - <PIEProceedingShareViewDelegate>
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
    
    PIEPageVM* vm = [_sourceToHelp objectAtIndex:_selectedIndexPath_toHelp.row];
    [self deleteOneToHelp:_selectedIndexPath_toHelp ID:vm.ID];
}

-(void)tapShareCancel {
    [self.shareView dismiss];
}


#pragma mark - <DZNEmptyDataSetSource>
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"还没认领帮P?就这样少了个炫（装）技（B）的机会咯？";
    
    NSDictionary *attributes =
    @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
      NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}




#pragma mark - <DZNEmptyDataSetDelegate>
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    /* 如果是因为第一次载入之前而数据源没有数据，那么就不要显示这个EmptyDataSet */
    if (_isfirstLoadingToHelp) {
        return NO;
    }
    else{
        return YES;
    }
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}


#pragma mark - Lazy loadings
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


@end
