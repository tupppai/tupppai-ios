//
//  ATOMPersonViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/3.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMPersonViewController.h"
#import "ATOMPersonView.h"
#import "ATOMPersonTableViewCell.h"
#import "ATOMAccountSettingViewController.h"
#import "ATOMMyFansViewController.h"
#import "ATOMMyConcernViewController.h"
#import "ATOMMyWorkViewController.h"
#import "ATOMMyUploadViewController.h"
#import "ATOMMyCollectionViewController.h"
#import "ATOMProfileEditViewController.h"
#import "ATOMProceedingViewController.h"
#import "ATOMHeaderImageCropperViewController.h"
#import "ATOMUploadImage.h"
#import "ATOMImage.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMPersonViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ATOMCropHeaderImageCompleteProtocol>

@property (nonatomic, strong) ATOMPersonView *personView;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, assign) ATOMClickUserHeaderEventType clickUserHeaderEventType;

@end

@implementation ATOMPersonViewController

#pragma mark - Lazy Initialize

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [UIImagePickerController new];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)createUI {
    _personView = [ATOMPersonView new];
    self.view = _personView;
    [_personView.userHeaderButton addTarget:self action:@selector(clickUserHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapFansGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFansGesture:)];
    [_personView.fansLabel addGestureRecognizer:tapFansGesture];
    _personView.personTableView.delegate = self;
    _personView.personTableView.dataSource = self;
    self.navigationItem.title = [ATOMCurrentUser currentUser].nickname;
    NSLog(@"[ATOMCurrentUser currentUser].nickname %@",[ATOMCurrentUser currentUser].nickname);
}

#pragma mark - Gesture Event

- (void)tapFansGesture:(UITapGestureRecognizer *)gesture {
    ATOMMyFansViewController *mfvc = [ATOMMyFansViewController new];
    [self pushViewController:mfvc animated:YES];
}

#pragma mark - Click Event

- (void)clickUserHeaderButton:(UIButton *)sender {
    [UIActionSheet showInView:self.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"更换头像", @"更换背景"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString *titleStr = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([titleStr isEqualToString:@"更换头像"]) {
            [self changingHeaderImage];
        } else if ([titleStr isEqualToString:@"更换背景"]) {
            [self changingBackGroundImage];
        }
    }];
}

- (void)dealTakingPhoto {
    _clickUserHeaderEventType = ATOMTakingPhoto;
    UIImagePickerControllerSourceType currentType = UIImagePickerControllerSourceTypeCamera;
    BOOL ok = [UIImagePickerController isSourceTypeAvailable:currentType];
    if (ok) {
        self.imagePickerController.sourceType = currentType;
        [self presentViewController:self.imagePickerController animated:YES completion:NULL];
    } else {
    }
}

- (void)changingHeaderImage {
    _clickUserHeaderEventType = ATOMChangingHeaderImage;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
}

- (void)changingBackGroundImage {
    _clickUserHeaderEventType = ATOMChangingBackGroundImage;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    WS(ws);
    [self dismissViewControllerAnimated:YES completion:^{
        if (_clickUserHeaderEventType == ATOMChangingBackGroundImage) {
            _personView.topBackGroundImageView.image = info[UIImagePickerControllerOriginalImage];
        } else if (_clickUserHeaderEventType == ATOMChangingHeaderImage) {
            ATOMHeaderImageCropperViewController *hicvc = [ATOMHeaderImageCropperViewController new];
            hicvc.delegate = self;
            hicvc.originImage = info[UIImagePickerControllerOriginalImage];
            [self pushViewController:hicvc animated:NO];
        }
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _personView.personTableView) {
        CGFloat sectionHeaderHeight = 15;
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 2;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            ATOMMyUploadViewController *muvc = [ATOMMyUploadViewController new];
            [self pushViewController:muvc animated:YES];
        } else if (row == 1) {
            ATOMMyWorkViewController *mwvc = [ATOMMyWorkViewController new];
            [self pushViewController:mwvc animated:YES];
        } else if (row == 2) {
            ATOMProceedingViewController *pvc = [ATOMProceedingViewController new];
            [self pushViewController:pvc animated:YES];
        } else if (row == 3) {
            ATOMMyCollectionViewController *mcvc = [ATOMMyCollectionViewController new];
            [self pushViewController:mcvc animated:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            ATOMMyConcernViewController *mcvc = [ATOMMyConcernViewController new];
            [self pushViewController:mcvc animated:YES];
        } else if (row == 1) {
            ATOMAccountSettingViewController *asvc = [ATOMAccountSettingViewController new];
            [self pushViewController:asvc animated:YES];
        }
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _S(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PersonCell";
    ATOMPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMPersonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            [cell configThemeLabelWith:@"我的求P"];
            [cell configThemeImageWith:[UIImage imageNamed:@"ic_my_ask"]];
            [cell addTopLine:YES];
            [cell addBottomLine:NO];
        } else if (row == 1) {
            [cell configThemeLabelWith:@"我的作品"];
            [cell configThemeImageWith:[UIImage imageNamed:@"ic_my_reply"]];
            [cell addTopLine:YES];
            [cell addBottomLine:NO];
        } else if (row == 2) {
            [cell configThemeLabelWith:@"进行中"];
            [cell configThemeImageWith:[UIImage imageNamed:@"ic_my_proceed"]];
            [cell addTopLine:YES];
            [cell addBottomLine:NO];
        } else if (row == 3) {
            [cell configThemeLabelWith:@"我的收藏"];
            [cell configThemeImageWith:[UIImage imageNamed:@"ic_my_fav"]];
            [cell addTopLine:YES];
            [cell addBottomLine:YES];
        }
    } else if (section == 1) {
        if (row == 0) {
            [cell configThemeLabelWith:@"我的关注"];
            [cell configThemeImageWith:[UIImage imageNamed:@"ic_my_focus"]];
            [cell addTopLine:YES];
            [cell addBottomLine:NO];
        } else if (row == 1) {
            [cell configThemeLabelWith:@"用户设置"];
            [cell configThemeImageWith:[UIImage imageNamed:@"ic_my_setting"]];
            [cell addTopLine:YES];
            [cell addBottomLine:YES];
            
        }
    }

    
    return cell;
}

#pragma ATOMCropHeaderImageCompleteProtocol

- (void)cropHeaderImageCompleteWith:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    [_personView.userHeaderButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    ATOMUploadImage *uploadImage = [ATOMUploadImage new];
    [uploadImage UploadImage:data WithBlock:^(ATOMImage *imageInformation, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return ;
        }
        [ATOMCurrentUser currentUser].avatar = imageInformation.imageURL;
    }];
}








@end
