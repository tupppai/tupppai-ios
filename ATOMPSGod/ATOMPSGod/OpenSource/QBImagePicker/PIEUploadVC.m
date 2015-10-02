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
#import "DDTabBarController.h"
#import "ATOMUploadImage.h"
#import "ATOMImage.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEUploadVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet SZTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *wordLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftShareButton;
@property (weak, nonatomic) IBOutlet UIButton *rightShareButton;

@property (strong, nonatomic) NSArray *imageArray;
@property (nonatomic, strong) ATOMImage *imageInfo1;
@property (nonatomic, strong) ATOMImage *imageInfo2;


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
    UIButton* itemView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 22)];
    [itemView setBackgroundImage:[UIImage imageNamed:@"pie_publish"] forState:UIControlStateNormal];  ;
    itemView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addTarget:self action:@selector(tapNext)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)setupViews {
    if (_type == PIEUploadTypeReply) {
        _inputTextView.placeholder = @"输入作品的亮点";
    }
    _inputTextView.delegate = self;
    _leftImageView.clipsToBounds = YES;
    _rightImageView.clipsToBounds = YES;
    if (_assetsArray.count == 1) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [UIImage imageNamed:@"plus_sign.jpg"];
        UITapGestureRecognizer* tapGesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iWantSelecteMorePhoto)];
        _rightImageView.userInteractionEnabled = YES;
        [_rightImageView addGestureRecognizer:tapGesure];
        _imageArray = [NSArray arrayWithObject:_leftImageView.image];
    } else if (_assetsArray.count == 2) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:1] type:ASSET_PHOTO_SCREEN_SIZE];
        _imageArray = [NSArray arrayWithObjects:_leftImageView.image,_rightImageView.image,nil];
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
    } else {
        if (_type == PIEUploadTypeAsk) {
            [self uploadAsk];
        } else if (_type == PIEUploadTypeReply) {
            [self uploadReply];
        }
    }
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
    }];
}
-(void) uploadAsk {
    [Hud activity:@"上传中" inView:self.view];
    if (_imageArray.count == 2) {
        [self uploadImage1:^(BOOL success) {
            if (success) {
                [self uploadImage2:^(BOOL success) {
                    if (success) {
                        [self uploadAskRestInfo:^(BOOL success) {
                            if (success) {
                                [self dismissToHome];
                            }
                        }];
                    }
                }];
            }
        }];
    } else if (_imageArray.count == 1) {
        [self uploadImage1:^(BOOL success) {
            if (success) {
                [self uploadAskRestInfo:^(BOOL success) {
                    if (success) {
                        [self dismissToHome];
                    }
                }];
            }
        }];
    }
}
- (void) uploadImage2:(void (^)(BOOL success))block {
    NSData *data = UIImageJPEGRepresentation(_imageArray[1], 1.0);
    ATOMUploadImage *uploadImage = [ATOMUploadImage new];
    [uploadImage UploadImage:data WithBlock:^(ATOMImage *imageInfo, NSError *error) {
        if (error) {
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
        ATOMUploadImage *uploadImage = [ATOMUploadImage new];
        [uploadImage UploadImage:data WithBlock:^(ATOMImage *imageInfo, NSError *error) {
            if (error) {
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
//            NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:newImageID],@"ID",[NSNumber numberWithInteger:newImageID],@"askID",@(PIEPageTypeAsk),@"type", nil];
//            DDInviteVC *ivc = [DDInviteVC new];
//            ws.newAskPageViewModel.ID = newImageID;
//            ivc.askPageViewModel = ws.newAskPageViewModel;
//            ivc.info = info;
//            ivc.showNext = YES;
//            [self pushViewController:ivc animated:YES];
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
    DDTabBarController *lvc = [AppDelegate APP].mainTabBarController;
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
