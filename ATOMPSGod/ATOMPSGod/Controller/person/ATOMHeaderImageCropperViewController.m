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
    self.title = @"头像裁剪";
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButtonItem:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    _headerImageCropperView = [ATOMHeaderImageCropperView new];
    self.view = _headerImageCropperView;
    _headerImageCropperView.originImage = _originImage;
}

#pragma mark - Click Event

- (void)clickLeftButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)clickRightButtonItem:(UIBarButtonItem *)barButtonItem {
    if ([_delegate respondsToSelector:@selector(cropHeaderImageCompleteWith:)]) {
        [_delegate cropHeaderImageCompleteWith:[_headerImageCropperView.imageCropperView getCroppedImage]];
    }
    [self.navigationController popViewControllerAnimated:NO];
}








































@end
