//
//  PIECameraViewController.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/15/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECameraViewController.h"
#import "QBImagePicker.h"
#import "PIEUploadVC.h"
#import "AppDelegate.h"
#import "PIETabBarController.h"
#import "DDNavigationController.h"
#import "PIEToHelpViewController.h"
#import "FXBlurView.h"

@interface PIECameraViewController () <QBImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *askBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *replyBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *askView;
@property (weak, nonatomic) IBOutlet UIImageView *replyView;
@property (weak, nonatomic) IBOutlet UIButton *closeView;

@property (nonatomic,strong) UIImage *image1;
@property (nonatomic,strong) UIImage *image2;

@property (nonatomic, strong) QBImagePickerController* QBImagePickerController;

@end

@implementation PIECameraViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    ((FXBlurView*)self.view).dynamic = NO;
    ((FXBlurView*)self.view).tintColor = [UIColor blackColor];
    DDNavigationController *nav = [AppDelegate APP].mainTabBarController.selectedViewController;
    ((FXBlurView*)self.view).underlyingView =   [nav.viewControllers objectAtIndex:0].view;
    ((FXBlurView*)self.view).blurRadius = 200;
    
    _askBackgroundView.layer.cornerRadius = _askBackgroundView.frame.size.width/2;
    _replyBackgroundView.layer.cornerRadius = _replyBackgroundView.frame.size.width/2;
    [_closeView addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    _bg1.userInteractionEnabled = YES;
    _bg2.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewController)];
    [self.view addGestureRecognizer:tapG];

    UITapGestureRecognizer* tapG1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnG1)];
    UITapGestureRecognizer* tapG2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnG2)];
    [_bg1 addGestureRecognizer:tapG1];
    [_bg2 addGestureRecognizer:tapG2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"进入发布页"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"离开发布页"];
}

- (void)tapOnG1 {
    [self presentViewController:self.QBImagePickerController animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:^{
//        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
//        [nav presentViewController:self.QBImagePickerController animated:YES completion:nil];
//    }];

}
- (void)tapOnG2 {
    [self dismissViewControllerAnimated:YES completion:^{
        DDNavigationController* nav = [AppDelegate APP].mainTabBarController.selectedViewController;
        PIEToHelpViewController* vc = [PIEToHelpViewController new];
        [nav pushViewController:vc animated:YES];
    }];
}
- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QBImagePickerController* )QBImagePickerController {
    if (!_QBImagePickerController) {
        _QBImagePickerController = [QBImagePickerController new];
        _QBImagePickerController.delegate = self;
        _QBImagePickerController.filterType = QBImagePickerControllerFilterTypePhotos;
        _QBImagePickerController.allowsMultipleSelection = YES;
        _QBImagePickerController.showsNumberOfSelectedAssets = YES;
        _QBImagePickerController.minimumNumberOfSelection = 1;
        _QBImagePickerController.maximumNumberOfSelection = 2;
//        _QBImagePickerController.prompt = @"选择你要上传的图片";
    }
    return _QBImagePickerController;
}


-(void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets {
    
//    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];

    NSMutableArray* array = [NSMutableArray new];
    for (ALAsset* asset in assets) {
        [array addObject:asset];
    }
    PIEUploadVC* vc = [PIEUploadVC new];
    vc.assetsArray = assets;
//    if (imagePickerController.maximumNumberOfSelection == 1) {
//        vc.hideSecondView = YES;
//        vc.type = PIEUploadTypeReply;
//    }
    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end
