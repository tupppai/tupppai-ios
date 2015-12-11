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
#import "PIEEntityImage.h"
#import "PIETagsView.h"
#import "PIETagModel.h"

@interface PIEUploadVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet SZTextView *inputTextView;
//@property (weak, nonatomic) IBOutlet UILabel *wordLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftShareButton;
@property (weak, nonatomic) IBOutlet UIButton *rightShareButton;

//@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableDictionary *uploadInfo;

@property (nonatomic, strong) PIEEntityImage *imageInfo1;
@property (nonatomic, strong) PIEEntityImage *imageInfo2;

@property (weak, nonatomic) IBOutlet UIView *shareBanner;
@property (weak, nonatomic) IBOutlet UILabel *label_chooseTag;
@property (weak, nonatomic) IBOutlet PIETagsView *view_tag;
@property (nonatomic, assign) BOOL succeedToDownloadTags;

@end

@implementation PIEUploadVC

-(BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self customNavigationBar];
    [self setupViews];
    if (_type == PIEUploadTypeAsk) {
        [self getSource];
    } else {
        _label_chooseTag.hidden = YES;
        _view_tag.hidden = YES;
    }
}

- (void)getSource {
    [DDBaseService GET:nil url:@"tag/index" block:^(id responseObject) {
        if (responseObject) {
            NSArray* data =[responseObject objectForKey:@"data"];
            NSMutableArray* array_model = [NSMutableArray new];
            for (NSDictionary* dic in data) {
                PIETagModel* model = [PIETagModel new];
                model.ID = [[dic objectForKey:@"id"]integerValue];
                model.text = [dic objectForKey:@"name"];
                [array_model addObject:model];
            }
            _view_tag.array_tagModel = array_model;
            
            if (array_model.count > 0) {
                _succeedToDownloadTags = YES;
            }
        }
    }];
}

- (void)customNavigationBar {
//    self.title = @"发布预览";
    UIButton* itemView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 22)];
    [itemView setBackgroundImage:[UIImage imageNamed:@"pie_publish"] forState:UIControlStateNormal];  ;
    itemView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addTarget:self action:@selector(tapNext)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    self.navigationItem.rightBarButtonItem = item;
    UILabel* label = [UILabel new];
    label.text = @"发布预览";
    label.font = [UIFont lightTupaiFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}
- (void)setupViews {
    _inputTextView.layer.borderColor = [UIColor colorWithHex:0x000000 andAlpha:0.3].CGColor;
    _inputTextView.layer.borderWidth = 0.5;
    _inputTextView.font = [UIFont lightTupaiFontOfSize:16];
    _label_chooseTag.font = [UIFont lightTupaiFontOfSize:14];
    _shareBanner.hidden = YES;
    if (_type == PIEUploadTypeReply) {
        _inputTextView.placeholder = @"输入你想对观众说的吧";
    } else  {
        _inputTextView.placeholder = @"写下你的图片需求吧";
    }
    _inputTextView.delegate = self;
    _leftImageView.clipsToBounds = YES;
    _rightImageView.clipsToBounds = YES;
//    _dataArray = [NSMutableArray array];
    _uploadInfo = [NSMutableDictionary new];
    if (_assetsArray.count == 1) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [UIImage imageNamed:@"pie_upload_plus"];
        UITapGestureRecognizer* tapGesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iWantSelecteMorePhoto)];
        _rightImageView.userInteractionEnabled = YES;
        [_rightImageView addGestureRecognizer:tapGesure];
        [_uploadInfo setObject:(_leftImageView.image) forKey:@"image1"];
        [_uploadInfo setObject:@1 forKey:@"imageCount"];

    } else if (_assetsArray.count == 2) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:1] type:ASSET_PHOTO_SCREEN_SIZE];
        
        [_uploadInfo setObject:(_leftImageView.image) forKey:@"image1"];
        [_uploadInfo setObject:(_rightImageView.image) forKey:@"image2"];
        [_uploadInfo setObject:@2 forKey:@"imageCount"];

    }
    
    if (_hideSecondView) {
        _rightImageView.hidden = YES;
    }
}
-(void) iWantSelecteMorePhoto {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) tapNext {
    if (_inputTextView.text.length == 0) {
        [self showWarnLabel];
    }
    //求p ； 如果tags没有下载下来 ，就不强求 ；必须选一个标签
    else if (_type == PIEUploadTypeAsk&& _succeedToDownloadTags && _view_tag.array_selectedId.count<=0 ) {
        [self showWarnLabel2];
    } else {
        if (_type == PIEUploadTypeAsk) {
            [_uploadInfo setObject:@"ask" forKey:@"type"];

        } else if (_type == PIEUploadTypeReply) {
            [_uploadInfo setObject:@"reply" forKey:@"type"];
        }
        
        [_uploadInfo setObject:_view_tag.array_selectedId forKey:@"tag_ids_array"];
        [_uploadInfo setObject:_inputTextView.text forKey:@"text_string"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"UploadCall" object:nil userInfo:_uploadInfo];
        [self backToTabbarController];
    }
}
//-(void) uploadReply {
//    [Hud activity:@"上传中" inView:self.view];
//    [self uploadImage1:^(BOOL success) {
//        if (success) {
//            [self uploadReplyRestInfo:^(BOOL success) {
//                if (success) {
//                    [self dismissToHome];
//                }
//            }];
//        }
//        else {
//            [Hud dismiss:self.view];
//        }
//    }];
//}
//-(void) uploadAsk {

//    [Hud activity:@"上传中" inView:self.view];
//    if (_dataArray.count == 2) {
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
//    } else if (_dataArray.count == 1) {
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
//}

- (void)backToTabbarController {
    PIETabBarController *lvc = [AppDelegate APP].mainTabBarController;
    [lvc dismissViewControllerAnimated:YES completion:nil];
    [lvc.selectedViewController popToRootViewControllerAnimated:YES];
//    [lvc setSelectedIndex:1];
}

//- (void) uploadImage2:(void (^)(BOOL success))block {
//    NSData *data = UIImageJPEGRepresentation(_dataArray[1], 1.0);
//    PIEUploadManager *uploadImage = [PIEUploadManager new];
//    [uploadImage UploadImage:data WithBlock:^(PIEEntityImage *imageInfo, NSError *error) {
//        if (!imageInfo) {
//            if (block) {
//                block(NO);
//            }
//        } else {
//            _imageInfo2 = imageInfo;
//            if (block) {
//                block(YES);
//            }
//        }
//    }];
//}

//- (void) uploadImage1:(void (^)(BOOL success))block {
//        NSData *data = UIImageJPEGRepresentation(_dataArray[0], 1.0);
//        PIEUploadManager *uploadImage = [PIEUploadManager new];
//        [uploadImage UploadImage:data WithBlock:^(PIEEntityImage *imageInfo, NSError *error) {
//            if (!imageInfo) {
//                if (block) {
//                    block(NO);
//                }
//            } else {
//                _imageInfo1 = imageInfo;
//                if (block) {
//                    block(YES);
//                }
//            }
//        }];
//}

//- (void)uploadAskRestInfo:(void (^) (BOOL success))block {
//    NSArray* uploadIds;
//    NSArray* ratios;
//    if (_assetsArray.count == 2) {
//        uploadIds = [NSArray arrayWithObjects:@(_imageInfo1.imageID),@(_imageInfo2.imageID), nil];
//        UIImage* image1 = _dataArray[0];
//        UIImage* image2 = _dataArray[1];
//        CGFloat ratio1 = image1.size.height/image1.size.width;
//        CGFloat ratio2 = image2.size.height/image2.size.width;
//        ratios = [NSArray arrayWithObjects:@(ratio1),@(ratio2), nil];
//    } else {
//        uploadIds = [NSArray arrayWithObjects:@(_imageInfo1.imageID), nil];
//        UIImage* image1 = _dataArray[0];
//        CGFloat ratio1 = image1.size.height/image1.size.width;
//        ratios = [NSArray arrayWithObjects:@(ratio1), nil];
//    }
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:uploadIds forKey:@"upload_ids"];
//    [param setObject:ratios forKey:@"ratios"];
//    [param setObject:_inputTextView.text forKey:@"desc"];
//    [DDService ddSaveAsk:param withBlock:^(NSInteger newImageID) {
//        [Hud dismiss:self.view];
//        [Hud dismiss];
//        if (newImageID!=-1) {
//            [self.view endEditing:YES];
//            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shouldNavToAskSegment"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            if  (block) {
//                block(YES);
//            }
//        } else {
//            [Hud error:@"求P失败,请重试"];
//            self.navigationItem.rightBarButtonItem.enabled = YES;
//            if  (block) {
//                block(NO);
//            }
//        }
//    }];
//}

//- (void)uploadReplyRestInfo:(void (^) (BOOL success))block {
//    
//    UIImage* image1 = _dataArray[0];
//    CGFloat ratio1 = image1.size.height/image1.size.width;
//    NSMutableDictionary *param = [NSMutableDictionary new];
//    [param setObject:@(ratio1) forKey:@"ratio"];
//    [param setObject:@(_imageInfo1.imageID) forKey:@"upload_id"];
//    [param setObject:@(_askIDToReply) forKey:@"ask_id"];
//    [param setObject:_inputTextView.text forKey:@"desc"];
//
//    [DDService ddSaveReply:param withBlock:^(BOOL success) {
//        [Hud dismiss:self.view];
//        [Hud dismiss];
//        if (success) {
//            [Hud success:@"提交作品成功"];
//            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shouldNavToHotSegment"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            if  (block) {
//                block(YES);
//            }
//        } else {
//            [Hud error:@"上传作品失败,请重试"];
//            self.navigationItem.rightBarButtonItem.enabled = YES;
//            if  (block) {
//                block(NO);
//            }
//        }
//    }];
//}

- (void)popToAlbumViewController {
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (void)dismissToHome {
    [self popToAlbumViewController];
    PIETabBarController *lvc = [AppDelegate APP].mainTabBarController;
    [lvc dismissViewControllerAnimated:NO completion:nil];
}
-(void)showWarnLabel {
    if (_type == PIEUploadTypeAsk) {
        [Hud text:@"输入你需要的效果吧"];
    } else if (_type == PIEUploadTypeReply) {
        [Hud text:@"请输入你对这个作品的想法"];
    }
}

-(void)showWarnLabel2 {
    [Hud text:@"必须添加一个标签"];
}
-(void)textViewDidChangeSelection:(UITextView *)textView {
//    if (textView.text.length > 18) {
//        NSString *shortString = [textView.text substringToIndex:18];
//        textView.text = shortString;
//    }
//    _wordLimitLabel.text = [NSString stringWithFormat:@"%zd/18",_inputTextView.text.length];
}


@end
