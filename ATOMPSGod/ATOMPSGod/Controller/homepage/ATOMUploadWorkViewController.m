//
//  ATOMUploadWorkViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/5.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMUploadWorkViewController.h"
#import "ATOMUploadWorkView.h"
#import "ATOMAddTipLabelToImageViewController.h"
#import "ATOMImageCropper.h"

@interface ATOMUploadWorkViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) ATOMUploadWorkView *uploadWorkView;

@end

@implementation ATOMUploadWorkViewController

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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    } else {
        return YES;
    }
}

- (void)createUI {
    self.title = @"上传图片";
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _uploadWorkView = [ATOMUploadWorkView new];
    _uploadWorkView.originImage = _originImage;
    self.view = _uploadWorkView;
    
    [_uploadWorkView.ThreeFourButton addTarget:self action:@selector(clickThreeFourButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView.OneOneButton addTarget:self action:@selector(clickOneOneButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView.FourThreeButton addTarget:self action:@selector(clickFourThreeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView.originButton addTarget:self action:@selector(clickOriginButton:) forControlEvents:UIControlEventTouchUpInside];
    [_uploadWorkView changeModeByOrder:@"origin"];
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


- (void)clickRightButtonItem:(UIBarButtonItem *)sender {
    ATOMAddTipLabelToImageViewController *atltivc = [ATOMAddTipLabelToImageViewController new];
    if (_uploadWorkView.imageOriginView) {
        atltivc.workImage = _uploadWorkView.originImage;
        NSLog(@"workImage size (%f,%f)", atltivc.workImage.size.width, atltivc.workImage.size.height);
    } else {
        atltivc.workImage = [_uploadWorkView.imageCropperView getCroppedImage];
        NSLog(@"workImage size (%f,%f)", atltivc.workImage.size.width, atltivc.workImage.size.height);
    }
    
    NSLog(@"%f %f", atltivc.workImage.size.width, atltivc.workImage.size.height);
    [self pushViewController:atltivc animated:YES];
}




























@end
