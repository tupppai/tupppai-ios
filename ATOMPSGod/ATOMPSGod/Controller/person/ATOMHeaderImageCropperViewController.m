//
//  ATOMHeaderImageCropperViewController.m
//  ATOMPSGod
//
//  Created by atom on 15/3/13.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMHeaderImageCropperViewController.h"
#import "ATOMHeaderImageCropperView.h"
#import "BJImageCropper.h"

@interface ATOMHeaderImageCropperViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) ATOMHeaderImageCropperView *headerImageCropperView;

@end

@implementation ATOMHeaderImageCropperViewController

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
    _headerImageCropperView = [ATOMHeaderImageCropperView new];
    self.view = _headerImageCropperView;
    _headerImageCropperView.originImage = _originImage;
    [_headerImageCropperView.cancelButton addTarget:self action:@selector(clickLeftButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_headerImageCropperView.confirmButton addTarget:self action:@selector(clickRightButtonItem:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Click Event

- (void)clickLeftButtonItem:(UIBarButtonItem *)barButtonItem {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    if ([_delegate respondsToSelector:@selector(cropHeaderImageCompleteWith:)]) {
        [_delegate cropHeaderImageCompleteWith:[_headerImageCropperView.imageCropperView getCroppedImage]];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}










@end
