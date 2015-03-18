//
//  ATOMHotDetailViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHotDetailViewController.h"
#import "ATOMHotDetailTableViewCell.h"
#import "ATOMCommentDetailViewController.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMOtherPersonViewController.h"
#import "ATOMHomePageViewModel.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMHotDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *hotDetailView;
@property (nonatomic, strong) UITableView *hotDetailTableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UITapGestureRecognizer *tapHotDetailGesture;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ATOMHotDetailViewController

#pragma mark - Lazy Initialize

- (UITableView *)hotDetailTableView {
    if (_hotDetailTableView == nil) {
        _hotDetailTableView = [[UITableView alloc] initWithFrame:_hotDetailView.bounds];
        _hotDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _hotDetailTableView.delegate = self;
        _hotDetailTableView.dataSource = self;
        _tapHotDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHotDetailGesture:)];
        [_hotDetailTableView addGestureRecognizer:_tapHotDetailGesture];
        [self configHotDetailTableViewRefresh];
    }
    return _hotDetailTableView;
}

- (UIView *)hotDetailView {
    if (_hotDetailView == nil) {
        _hotDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
        [_hotDetailView addSubview:self.hotDetailTableView];
    }
    return _hotDetailView;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark Refresh

- (void)configHotDetailTableViewRefresh {
    WS(ws);
    [_hotDetailTableView addLegendHeaderWithRefreshingBlock:^{
        [ws loadNewHotData];
    }];
    [_hotDetailTableView addLegendFooterWithRefreshingBlock:^{
        [ws loadMoreHotData];
    }];
}

- (void)loadNewHotData {
    WS(ws);
    [ws.hotDetailTableView.header endRefreshing];
}

- (void)loadMoreHotData {
    WS(ws);
    [ws.hotDetailTableView.footer endRefreshing];
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i];
        UIImage *img = [UIImage imageNamed:imgName];
        ATOMHomePageViewModel *viewModel = [ATOMHomePageViewModel new];
        viewModel.userImage = img;
        [_dataSource addObject:viewModel];
    }
    [_hotDetailTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)createUI {
    self.title = @"详情";
    self.view = self.hotDetailView;
}

#pragma mark - Click Event

- (void)dealDownloadWork {
    
}

- (void)dealUploadWork {
    [[NSUserDefaults standardUserDefaults] setObject:@"Uploading" forKey:@"UploadingOrSeekingHelp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)popCurrentController {
    if (_pushType == ATOMCommentMessageType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_pushType == ATOMInviteMessageType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_pushType == ATOMTopicReplyMessageType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_pushType == ATOMMyUploadType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_pushType == ATOMMyWorkType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_pushType == ATOMProceedingType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (_pushType == ATOMMyCollectionType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Gesture Event

- (void)tapHotDetailGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_hotDetailTableView];
    NSIndexPath *indexPath = [_hotDetailTableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMHotDetailTableViewCell *cell = (ATOMHotDetailTableViewCell *)[_hotDetailTableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.userWorkImageView.frame, p)) {
            NSLog(@"Click userWorkImageView");
        } else if (CGRectContainsPoint(cell.topView.frame, p)) {
            p = [gesture locationInView:cell.topView];
            if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
//                NSLog(@"Click userHeaderButton");
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                [self pushViewController:opvc animated:YES];
            } else if (CGRectContainsPoint(cell.psButton.frame, p)) {
                NSLog(@"Click psButton");
                [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"下载素材",@"上传作品"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                    NSString *actionSheetTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
                    if ([actionSheetTitle isEqualToString:@"下载素材"]) {
                        [self dealDownloadWork];
                    } else if ([actionSheetTitle isEqualToString:@"上传作品"]) {
                        [self dealUploadWork];
                    }
                }];
            } else if (CGRectContainsPoint(cell.userNameLabel.frame, p)) {
                ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
                [self pushViewController:opvc animated:YES];
            }
        } else {
            p = [gesture locationInView:cell.thinCenterView];
            if (CGRectContainsPoint(cell.praiseButton.frame, p)) {
                cell.praiseButton.selected = !cell.praiseButton.selected;
            } else if (CGRectContainsPoint(cell.shareButton.frame, p)) {
                NSLog(@"Click shareButton");
            } else if (CGRectContainsPoint(cell.commentButton.frame, p)) {
                ATOMCommentDetailViewController *cdvc = [ATOMCommentDetailViewController new];
                [self pushViewController:cdvc animated:YES];
            }
        }
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        ATOMUploadWorkViewController *uwvc = [ATOMUploadWorkViewController new];
        uwvc.originImage = info[UIImagePickerControllerOriginalImage];
        [ws pushViewController:uwvc animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HotDetailCell";
    ATOMHotDetailTableViewCell *cell = [_hotDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMHotDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.viewModel = _dataSource[indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMHotDetailTableViewCell calculateCellHeightWith:_dataSource[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
