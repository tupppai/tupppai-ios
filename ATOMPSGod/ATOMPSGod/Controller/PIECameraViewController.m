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
#import "DDTabBarController.h"
#import "DDNavigationController.h"
#define ASSET_PHOTO_THUMBNAIL           0
#define ASSET_PHOTO_ASPECT_THUMBNAIL    1
#define ASSET_PHOTO_SCREEN_SIZE         2
#define ASSET_PHOTO_FULL_RESOLUTION     3

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _askBackgroundView.layer.cornerRadius = _askBackgroundView.frame.size.width/2;
    _replyBackgroundView.layer.cornerRadius = _replyBackgroundView.frame.size.width/2;
    [_closeView addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    
    _bg1.userInteractionEnabled = YES;
    _bg2.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapG1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnG1)];
    UITapGestureRecognizer* tapG2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnG2)];
    [_bg1 addGestureRecognizer:tapG1];
    [_bg2 addGestureRecognizer:tapG2];

}

- (void)tapOnG1 {
    //    [self.navigationController pushViewController:self.QBImagePickerController animated:YES];

//    DDNavigationController* nav = [[DDNavigationController alloc]initWithRootViewController:self.QBImagePickerController];
    [self presentViewController:self.QBImagePickerController animated:YES completion:nil];
}
- (void)tapOnG2 {
    
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
    
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];

    NSMutableArray* imageArray = [NSMutableArray new];
    for (ALAsset* asset in assets) {
        [imageArray addObject:[self getImageFromAsset:asset type:ASSET_PHOTO_FULL_RESOLUTION]];
    }
    PIEUploadVC* vc = [PIEUploadVC new];
    vc.imageArray = imageArray;
    [imagePickerController.albumsNavigationController pushViewController:vc animated:YES];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self.QBImagePickerController.selectedAssetURLs removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage *)getImageFromAsset:(ALAsset *)asset type:(NSInteger)nType
{
    CGImageRef iRef = nil;
    
    if (nType == ASSET_PHOTO_THUMBNAIL)
        iRef = [asset thumbnail];
    else if (nType == ASSET_PHOTO_ASPECT_THUMBNAIL)
        iRef = [asset aspectRatioThumbnail];
    else if (nType == ASSET_PHOTO_SCREEN_SIZE)
        iRef = [asset.defaultRepresentation fullScreenImage];
    else if (nType == ASSET_PHOTO_FULL_RESOLUTION)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        if (strXMP == nil || [strXMP isKindOfClass:[NSNull class]])
        {
            iRef = [asset.defaultRepresentation fullResolutionImage];
            return [UIImage imageWithCGImage:iRef scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        }
        else
        {
            NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
            
            CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
            
            NSError *error = nil;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                         inputImageExtent:image.extent
                                                                    error:&error];
            if (error) {
                NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
            }
            
            for (CIFilter *filter in filterArray) {
                [filter setValue:image forKey:kCIInputImageKey];
                image = [filter outputImage];
            }
            
            UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            return iImage;
        }
    }
    
    return [UIImage imageWithCGImage:iRef];
}

@end
