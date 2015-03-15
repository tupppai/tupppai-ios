//
//  ATOMProceedingViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/11.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMProceedingViewController.h"
#import "ATOMProceedingTableViewCell.h"
#import "ATOMUploadWorkViewController.h"
#import "ATOMHotDetailViewController.h"
#import "ATOMOtherPersonViewController.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface ATOMProceedingViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *proceedingView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tapProceedingGesture;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@end

@implementation ATOMProceedingViewController

#pragma mark - Lazy Initialize

- (UITapGestureRecognizer *)tapProceedingGesture {
    if (!_tapProceedingGesture) {
        _tapProceedingGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProceedingGesture:)];
    }
    return _tapProceedingGesture;
}

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

- (void)createUI {
    self.title = @"进行中";
    _proceedingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    self.view = _proceedingView;
    _tableView = [[UITableView alloc] initWithFrame:_proceedingView.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_proceedingView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView addGestureRecognizer:self.tapProceedingGesture];
}

#pragma mark - Gesture Event

- (void)tapProceedingGesture:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:location];
    if (indexPath) {
        ATOMProceedingTableViewCell *cell = (ATOMProceedingTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        CGPoint p = [gesture locationInView:cell];
        //点击图片
        if (CGRectContainsPoint(cell.uploadButton.frame, p)) {
            [self dealUploadWork];
        } else if (CGRectContainsPoint(cell.userUploadImageView.frame, p)) {
            ATOMHotDetailViewController *hdvc = [ATOMHotDetailViewController new];
            hdvc.pushType = ATOMProceedingType;
            [self pushViewController:hdvc animated:YES];
        } else if (CGRectContainsPoint(cell.userHeaderButton.frame, p)) {
            ATOMOtherPersonViewController *opvc = [ATOMOtherPersonViewController new];
            [self pushViewController:opvc animated:YES];
        }
    }
}

#pragma mark - Click Event

- (void)dealUploadWork {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:_imagePickerController animated:YES completion:NULL];
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
    static NSString *CellIdentifier = @"ProceedingCell";
    ATOMProceedingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[ATOMProceedingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ATOMProceedingTableViewCell calculateCellHeight];
}



























@end
