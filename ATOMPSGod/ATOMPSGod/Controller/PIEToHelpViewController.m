//
//  PIEToHelpViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 10/9/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEToHelpViewController.h"
#import "QBImagePickerController.h"
#import "RefreshTableView.h"
#import "PIEProceedingManager.h"
#import "PIEUploadVC.h"
#import "PIEToHelpTableViewCell2.h"
#import "PIEFriendViewController.h"
#import "PIEReplyCarouselViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEToHelpViewController () <UITableViewDataSource,UITableViewDelegate,PWRefreshBaseTableViewDelegate,QBImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableArray *sourceToHelp;
@property (nonatomic, assign) NSInteger currentIndex_ToHelp;
@property (nonatomic, assign) BOOL canRefreshToHelpFooter;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;
@property (nonatomic, strong) RefreshTableView *toHelpTableView;

@end

@implementation PIEToHelpViewController
-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _canRefreshToHelpFooter = YES;
    _currentIndex_ToHelp = 1;
    _sourceToHelp = [NSMutableArray new];
    
    _toHelpTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TAB_HEIGHT)];
    _toHelpTableView.backgroundColor = [UIColor clearColor];
    _toHelpTableView.dataSource = self;
    _toHelpTableView.delegate = self;
    _toHelpTableView.psDelegate = self;
    self.view = _toHelpTableView;
    UINib* nib = [UINib nibWithNibName:@"PIEToHelpTableViewCell2" bundle:nil];
    [_toHelpTableView registerNib:nib forCellReuseIdentifier:@"PIEToHelpTableViewCell2"];
    UITapGestureRecognizer* tapToHelpTableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHelpTableViewGesture:)];
    [_toHelpTableView addGestureRecognizer:tapToHelpTableViewGesture];
    [self getRemoteSourceToHelp];
}

- (void)tapToHelpTableViewGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_toHelpTableView];
    NSIndexPath *indexPath = [_toHelpTableView indexPathForRowAtPoint:location];
    _selectedIndexPath = indexPath;
    DDPageVM* vm = [_sourceToHelp objectAtIndex:indexPath.row];
    if (indexPath) {
        PIEToHelpTableViewCell2 *cell = (PIEToHelpTableViewCell2 *)[_toHelpTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];

        if (CGRectContainsPoint(cell.deleteView.frame, p)) {
            [self deleteOneToHelp:indexPath ID:vm.ID];
        }
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
            PIEReplyCarouselViewController* vc = [PIEReplyCarouselViewController new];
            vm.image = cell.theImageView.image;
            vc.pageVM = vm;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self presentViewController:self.QBImagePickerController animated:YES completion:nil];
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

#pragma mark - getRemoteSourceToHelp

- (void)getRemoteSourceToHelp {
    WS(ws);
    [_toHelpTableView.footer endRefreshing];
    _currentIndex_ToHelp = 1;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(1) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    [PIEProceedingManager getMyToHelp:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sourceToHelp removeAllObjects];
            [ws.sourceToHelp addObjectsFromArray:sourceAgent];
            [ws.toHelpTableView reloadData];
        }
        [ws.toHelpTableView.header endRefreshing];
    }];
}

- (void)getMoreRemoteSourceToHelp {
    WS(ws);
    _currentIndex_ToHelp ++;
    [_toHelpTableView.header endRefreshing];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_currentIndex_ToHelp) forKey:@"page"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    [param setObject:@(20) forKey:@"size"];
    [PIEProceedingManager getMyToHelp:param withBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            _canRefreshToHelpFooter = NO;
        } else {
            _canRefreshToHelpFooter = YES;
            NSMutableArray* sourceAgent = [NSMutableArray new];
            for (PIEPageEntity *homeImage in resultArray) {
                DDPageVM *vm = [[DDPageVM alloc]initWithPageEntity:homeImage];
                [sourceAgent addObject:vm];
            }
            [ws.sourceToHelp addObjectsFromArray:sourceAgent];
            [ws.toHelpTableView reloadData];
        }
        [ws.toHelpTableView.footer endRefreshing];
    }];
}


-(void)didPullRefreshDown:(UITableView *)tableView {
    [self getRemoteSourceToHelp];
}
-(void)didPullRefreshUp:(UITableView *)tableView {
    if (_canRefreshToHelpFooter) {
        [self getMoreRemoteSourceToHelp];
    } else {
        [_toHelpTableView.footer endRefreshing];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


@end