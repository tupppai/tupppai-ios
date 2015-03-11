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

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ATOMHotDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *hotDetailView;
@property (nonatomic, strong) UITableView *hotDetailTableView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UITapGestureRecognizer *tapHotDetailGesture;

@end

@implementation ATOMHotDetailViewController

#pragma mark - Lazy Initialize

- (UITableView *)hotDetailTableView {
    if (_hotDetailTableView == nil) {
        _hotDetailTableView = [[UITableView alloc] init];
        _hotDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _hotDetailTableView.delegate = self;
        _hotDetailTableView.dataSource = self;
        _tapHotDetailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHotDetailGesture:)];
        [_hotDetailTableView addGestureRecognizer:_tapHotDetailGesture];
    }
    return _hotDetailTableView;
}

- (UIView *)hotDetailView {
    if (_hotDetailView == nil) {
        _hotDetailView = [UIView new];
        [_hotDetailView addSubview:self.hotDetailTableView];
    }
    return _hotDetailView;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [UIImagePickerController new];
    }
    return _imagePickerController;
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    WS(ws);
    self.title = @"详情";
    self.view = self.hotDetailView;
    [self.hotDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark - Click Event

- (void)dealDownloadWork {
    
}

- (void)dealUploadWork {
    UIImagePickerControllerSourceType currentType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:currentType];
    if (ok) {
        self.imagePickerController.sourceType = currentType;
        _imagePickerController.delegate = self;
        [self presentViewController:_imagePickerController animated:YES completion:NULL];
    } else {
        
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
                NSLog(@"Click userHeaderButton");
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"HotDetailCell";
    ATOMHotDetailTableViewCell *cell = [_hotDetailTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMHotDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell layoutSubviews];
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMHotDetailTableViewCell calculateCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
