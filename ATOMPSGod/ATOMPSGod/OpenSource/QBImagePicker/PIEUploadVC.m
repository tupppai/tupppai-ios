//
//  PIEUploadVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/10/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEUploadVC.h"
#import "SZTextView.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
#import "PIETabBarController.h"
#import "PIEUploadManager.h"
#import "ATOMImage.h"



@interface PIEUploadVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet SZTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *wordLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftShareButton;
@property (weak, nonatomic) IBOutlet UIButton *rightShareButton;

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (nonatomic, strong) ATOMImage *imageInfo1;
@property (nonatomic, strong) ATOMImage *imageInfo2;

@property (weak, nonatomic) IBOutlet UIView *shareBanner;

@end

@implementation PIEUploadVC

-(BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationBar];
    [self setupViews];
    
}

- (void)customNavigationBar {
    self.title = @"发布预览";
    UIButton* itemView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 22)];
    [itemView setBackgroundImage:[UIImage imageNamed:@"pie_publish"] forState:UIControlStateNormal];  ;
    itemView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addTarget:self action:@selector(tapNext)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)setupViews {
    _shareBanner.hidden = YES;
    if (_type == PIEUploadTypeReply) {
        _inputTextView.placeholder = @"输入你想对观众说的吧";
    } else  {
        _inputTextView.placeholder = @"写下你的图片需求吧";
    }
    _inputTextView.delegate = self;
    _leftImageView.clipsToBounds = YES;
    _rightImageView.clipsToBounds = YES;
    _imageArray = [NSMutableArray array];
    
    if (_assetsArray.count == 1) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [UIImage imageNamed:@"pie_upload_plus"];
        UITapGestureRecognizer* tapGesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iWantSelecteMorePhoto)];
        _rightImageView.userInteractionEnabled = YES;
        [_rightImageView addGestureRecognizer:tapGesure];
        NSData* data1 = UIImagePNGRepresentation(_leftImageView.image);
        [_imageArray addObject:UIImagePNGRepresentation(_leftImageView.image)];
        NSLog(@"data size %zd",data1.length);
    } else if (_assetsArray.count == 2) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:1] type:ASSET_PHOTO_SCREEN_SIZE];
        NSData* data1 = UIImagePNGRepresentation(_leftImageView.image);
        NSData* data2 = UIImagePNGRepresentation(_rightImageView.image);

        [_imageArray addObjectsFromArray:[NSArray arrayWithObjects:UIImagePNGRepresentation(_leftImageView.image),UIImagePNGRepresentation(_rightImageView.image),nil]];
        NSLog(@"data size %zd , size2 %zd",data1.length,data2.length);

    }
    
    if (_hideSecondView) {
        _rightImageView.hidden = YES;
    }
}
-(void) iWantSelecteMorePhoto {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) tapNext {
    
    
//    if (_inputTextView.text.length == 0) {
//            [self showWarnLabel];
//    } else {
        if (_type == PIEUploadTypeAsk) {
            [_imageArray insertObject:@"ask" atIndex:0];
        } else if (_type == PIEUploadTypeReply) {
            [_imageArray insertObject:@"reply" atIndex:0];
        }
//    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"ToUpload.dat"];
    [_imageArray writeToFile:yourArrayFileName atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shouldDoUploadJob"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UploadRightNow" object:nil];
    [self backToPIENewViewController];
}
-(void) uploadReply {
    [Hud activity:@"上传中" inView:self.view];
    [self uploadImage1:^(BOOL success) {
        if (success) {
            [self uploadReplyRestInfo:^(BOOL success) {
                if (success) {
                    [self dismissToHome];
                }
            }];
        }
        else {
            [Hud dismiss:self.view];
        }
    }];
}
-(void) uploadAsk {
    
//    [Hud activity:@"上传中" inView:self.view];
//    if (_imageArray.count == 2) {
//        [self uploadImage1:^(BOOL success) {
//            if (success) {
//                [self uploadImage2:^(BOOL success) {
//                    if (success) {
//                        [self uploadAskRestInfo:^(BOOL success) {
//                            if (success) {
//                                [self dismissToHome];
//                            }
//                        }];
//                    }
//                }];
//            }
//            else {
//                [Hud dismiss:self.view];
//            }
//        }
//         ];
//    } else if (_imageArray.count == 1) {
//        [self uploadImage1:^(BOOL success) {
//            if (success) {
//                [self uploadAskRestInfo:^(BOOL success) {
//                    if (success) {
//                        [self dismissToHome];
//                    }
//                }];
//            }
//            else {
//                [Hud dismiss:self.view];
//            }
//        }];
//    }
}

- (void)backToPIENewViewController {
    PIETabBarController *lvc = [AppDelegate APP].mainTabBarController;
    [lvc dismissViewControllerAnimated:YES completion:nil];
    [lvc.selectedViewController popToRootViewControllerAnimated:YES];
    [lvc setSelectedIndex:1];
}

- (void) uploadImage2:(void (^)(BOOL success))block {
    NSData *data = UIImageJPEGRepresentation(_imageArray[1], 1.0);
    PIEUploadManager *uploadImage = [PIEUploadManager new];
    [uploadImage UploadImage:data WithBlock:^(ATOMImage *imageInfo, NSError *error) {
        if (!imageInfo) {
            if (block) {
                block(NO);
            }
        } else {
            _imageInfo2 = imageInfo;
            if (block) {
                block(YES);
            }
        }
    }];
}

- (void) uploadImage1:(void (^)(BOOL success))block {
        NSData *data = UIImageJPEGRepresentation(_imageArray[0], 1.0);
        PIEUploadManager *uploadImage = [PIEUploadManager new];
        [uploadImage UploadImage:data WithBlock:^(ATOMImage *imageInfo, NSError *error) {
            if (!imageInfo) {
                if (block) {
                    block(NO);
                }
            } else {
                _imageInfo1 = imageInfo;
                if (block) {
                    block(YES);
                }
            }
        }];
}

- (void)uploadAskRestInfo:(void (^) (BOOL success))block {
    NSArray* uploadIds;
    NSArray* ratios;
    if (_assetsArray.count == 2) {
        uploadIds = [NSArray arrayWithObjects:@(_imageInfo1.imageID),@(_imageInfo2.imageID), nil];
        UIImage* image1 = _imageArray[0];
        UIImage* image2 = _imageArray[1];
        CGFloat ratio1 = image1.size.height/image1.size.width;
        CGFloat ratio2 = image2.size.height/image2.size.width;
        ratios = [NSArray arrayWithObjects:@(ratio1),@(ratio2), nil];
    } else {
        uploadIds = [NSArray arrayWithObjects:@(_imageInfo1.imageID), nil];
        UIImage* image1 = _imageArray[0];
        CGFloat ratio1 = image1.size.height/image1.size.width;
        ratios = [NSArray arrayWithObjects:@(ratio1), nil];
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:uploadIds forKey:@"upload_ids"];
    [param setObject:ratios forKey:@"ratios"];
    [param setObject:_inputTextView.text forKey:@"desc"];
    [DDService ddSaveAsk:param withBlock:^(NSInteger newImageID) {
        [Hud dismiss:self.view];
        [Hud dismiss];
        if (newImageID!=-1) {
            [self.view endEditing:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shouldNavToAskSegment"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if  (block) {
                block(YES);
            }
        } else {
            [Hud error:@"求P失败,请重试"];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if  (block) {
                block(NO);
            }
        }
    }];
}

- (void)uploadReplyRestInfo:(void (^) (BOOL success))block {
    
    UIImage* image1 = _imageArray[0];
    CGFloat ratio1 = image1.size.height/image1.size.width;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(ratio1) forKey:@"ratio"];
    [param setObject:@(_imageInfo1.imageID) forKey:@"upload_id"];
    [param setObject:@(_askIDToReply) forKey:@"ask_id"];
    [param setObject:_inputTextView.text forKey:@"desc"];

    [DDService ddSaveReply:param withBlock:^(BOOL success) {
        [Hud dismiss:self.view];
        [Hud dismiss];
        if (success) {
            [Hud success:@"提交作品成功"];
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shouldNavToHotSegment"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if  (block) {
                block(YES);
            }
        } else {
            [Hud error:@"上传作品失败,请重试"];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            if  (block) {
                block(NO);
            }
        }
    }];
}
- (void)popToAlbumViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)dismissToHome {
    [self popToAlbumViewController];
    PIETabBarController *lvc = [AppDelegate APP].mainTabBarController;
    [lvc dismissViewControllerAnimated:NO completion:nil];
}
-(void)showWarnLabel {
    [TSMessage showNotificationWithTitle:@"求p内容不能为空"
                                subtitle:@"。"
                                    type:TSMessageNotificationTypeWarning];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor =[UIColor darkGrayColor];
}

-(void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView.text.length > 18) {
        NSString *shortString = [textView.text substringToIndex:18];
        textView.text = shortString;
    }
    _wordLimitLabel.text = [NSString stringWithFormat:@"%zd/18",_inputTextView.text.length];
}


@end
