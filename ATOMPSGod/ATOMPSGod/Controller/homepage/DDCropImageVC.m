//
//  ATOMCropImageController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDCropImageVC.h"
#import "ATOMUploadWorkView.h"
#import "DDAddTipLabelVC.h"
#import "ATOMImageCropper.h"
#import "BJImageCropper.h"

@interface DDCropImageVC () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ATOMUploadWorkView *uploadWorkView;

@end

@implementation DDCropImageVC

#pragma mark - Lazy Initialize


#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    } else {
        return YES;
    }
}

- (void)createUI {
    _uploadWorkView = [ATOMUploadWorkView new];
    _uploadWorkView.originImage = _originImage;
    self.view = _uploadWorkView;
    [_uploadWorkView.ThreeFourButton addTarget:self action:@selector(clickThreeFourButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView.OneOneButton addTarget:self action:@selector(clickOneOneButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView.FourThreeButton addTarget:self action:@selector(clickFourThreeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView.originButton addTarget:self action:@selector(clickOriginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView changeModeByOrder:@"origin"];
    [_uploadWorkView.cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView.confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - Click Event

- (void)clickThreeFourButton:(UIButton *)sender {
    [_uploadWorkView changeModeByOrder:@"3:4"];
}

- (void)clickOneOneButton:(UIButton *)sender {
    [_uploadWorkView changeModeByOrder:@"1:1"];
}

- (void)clickFourThreeButton:(UIButton *)sender {
    [_uploadWorkView changeModeByOrder:@"4:3"];
}

- (void)clickOriginButton:(UIButton *)sender {
    [_uploadWorkView changeModeByOrder:@"origin"];
}

- (void)clickCancelButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickConfirmButton:(UIButton *)sender {
    DDAddTipLabelVC *atltivc = [DDAddTipLabelVC new];
    if (_uploadWorkView.imageOriginView) {
        atltivc.workImage = _uploadWorkView.originImage;
    } else {
        atltivc.workImage = [_uploadWorkView.imageCropperView getCroppedImage];
    }
    atltivc.askPageViewModel = _askPageViewModel;
    [self.navigationController pushViewController:atltivc animated:YES];
}




























@end
