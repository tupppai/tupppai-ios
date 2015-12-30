//
//  PIEToHelpViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEToHelpViewController.h"
#import "QBImagePickerController.h"
#import "PIERefreshTableView.h"
#import "PIEProceedingManager.h"
#import "PIEUploadVC.h"
#import "PIEToHelpTableViewCell2.h"
#import "PIEFriendViewController.h"
#import "PIECarouselViewController2.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
//#import "UITableView+FDTemplateLayoutCell.h"
#import "DeviceUtil.h"
#import "PIECategoryModel.h"
//#import "PIEUploadManager.h"

@interface PIEToHelpViewController () <UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,QBImagePickerControllerDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) NSMutableArray *sourceToHelp;
@property (nonatomic, assign) NSInteger currentIndex_ToHelp;
@property (nonatomic, assign) BOOL canRefreshToHelpFooter;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;
@property (nonatomic, strong) PIERefreshTableView *toHelpTableView;
@property (nonatomic, assign) BOOL isfirstLoading;

@end

@implementation PIEToHelpViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择帮P任务";
    _canRefreshToHelpFooter = YES;
    _currentIndex_ToHelp = 1;
    _sourceToHelp = [NSMutableArray new];
    
    _toHelpTableView = [[PIERefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    _toHelpTableView.backgroundColor = [UIColor whiteColor];
    _toHelpTableView.dataSource = self;
    _toHelpTableView.delegate = self;
    _toHelpTableView.emptyDataSetDelegate = self;
    _toHelpTableView.emptyDataSetSource = self;
    _toHelpTableView.psDelegate = self;
    _toHelpTableView.separatorColor = [UIColor colorWithHex:0x000000 andAlpha:0.1];
    _toHelpTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _toHelpTableView.estimatedRowHeight = 100;
    _toHelpTableView.rowHeight = UITableViewAutomaticDimension;
    self.view = _toHelpTableView;
    UINib* nib = [UINib nibWithNibName:@"PIEToHelpTableViewCell2" bundle:nil];
    [_toHelpTableView registerNib:nib forCellReuseIdentifier:@"PIEToHelpTableViewCell2"];
    UITapGestureRecognizer* tapToHelpTableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHelpTableViewGesture:)];
    [_toHelpTableView addGestureRecognizer:tapToHelpTableViewGesture];
    _isfirstLoading = YES;
    [self getRemoteSourceToHelp];
}

- (void)tapToHelpTableViewGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_toHelpTableView];
    NSIndexPath *indexPath = [_toHelpTableView indexPathForRowAtPoint:location];
    _selectedIndexPath = indexPath;
    PIEPageVM* vm = [_sourceToHelp objectAtIndex:indexPath.row];
    if (indexPath) {
        PIEToHelpTableViewCell2 *cell = (PIEToHelpTableViewCell2 *)[_toHelpTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];

//        if (CGRectContainsPoint(cell.deleteView.frame, p)) {
//            [self deleteOneToHelp:indexPath ID:vm.ID];
//        }
//        else
            if (CGRectContainsPoint(cell.avatarView.frame, p)) {
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
            PIECarouselViewController2* vc = [PIECarouselViewController2 new];
            vc.pageVM = vm;
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else {
//            DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
            [[AppDelegate APP].mainTabBarController presentViewController:self.QBImagePickerController animated:YES completion:nil];
        }
    }
}


#pragma mark - getRemoteSourceToHelp

- (void)getRemoteSourceToHelp {
    WS(ws);
    [_toHelpTableView.mj_footer endRefreshing];
    _currentIndex_ToHelp = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    if (_channelVM) {
        [param setObject:@(_channelVM.ID) forKey:@"category_id"];
    }
    [PIEProceedingManager getMyToHelp:param withBlock:^(NSMutableArray *resultArray) {
        _isfirstLoading = NO;
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageModel *homeImage in resultArray) {
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
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_currentIndex_ToHelp) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH*0.5) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    if (_channelVM) {
        [param setObject:@(_channelVM.ID) forKey:@"category_id"];
    }
    

    [PIEProceedingManager getMyToHelp:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageModel *homeImage in resultArray) {
                PIEPageVM *vm = [[PIEPageVM alloc]initWithPageEntity:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sourceToHelp addObjectsFromArray:sourceAgent];
            [ws.toHelpTableView reloadData];
        }
        [ws.toHelpTableView.mj_footer endRefreshing];
    }];
}


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


-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    NSMutableArray* array = [NSMutableArray new];
    for (ALAsset* asset in assets) {
        [array addObject:asset];
    }
    PIEUploadVC* vc = [PIEUploadVC new];
    vc.assetsArray = assets;
    vc.hideSecondView = YES;
    PIEPageVM* vm = [_sourceToHelp objectAtIndex:_selectedIndexPath.row];
    
    if (vm.models_catogory && vm.models_catogory.count>0) {
        PIECategoryModel *model = [vm.models_catogory objectAtIndex:0];
        [PIEUploadManager shareModel].channel_id = [model.ID integerValue];
    }
    [PIEUploadManager shareModel].ask_id = vm.askID;
    [PIEUploadManager shareModel].type = PIEPageTypeReply;

    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
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
    PIEToHelpTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"PIEToHelpTableViewCell2"];
    if (!cell) {
        cell = [[PIEToHelpTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PIEToHelpTableViewCell2"];
    }
    [cell injectSource:[_sourceToHelp objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:@"PIEToHelpTableViewCell2"  cacheByIndexPath:indexPath configuration:^(PIEToHelpTableViewCell2 *cell) {
//        [cell injectSource:[_sourceToHelp objectAtIndex:indexPath.row]];
//    }];
//}


#pragma mark - DZNEmptyDataSetSource & delegate
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"pie_empty"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没有帮P的数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:kTitleSizeForEmptyDataSet],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !_isfirstLoading;
}
-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
