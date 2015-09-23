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
    UIButton* itemView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 22)];
    [itemView setBackgroundImage:[UIImage imageNamed:@"pie_publish"] forState:UIControlStateNormal];  ;
    itemView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addTarget:self action:@selector(tapNext)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    self.navigationItem.rightBarButtonItem = item;
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
    NSLog(@"iWantSelecteMoreOPhoto");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) tapNext {
    if (_inputTextView.text.length == 0) {
            [self showWarnLabel];
    } else {
        if (_type == PIEUploadTypeAsk) {
            [self uploadAsk];
        } else if (_type = PIEUploadTypeReply) {
            [self uploadReply];
        }
    }
}
-(void) uploadReply {
    [Hud activity:@"上传中" inView:self.view];
    [self uploadImage1:^(BOOL success) {
        if (success) {
            [self uploadAskRestInfo:^(BOOL success) {
                if (success) {
                    [self setTabBarToBeRootViewController];
                }
            }];
        }
    }]
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
                                [self setTabBarToBeRootViewController];
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
                        [self setTabBarToBeRootViewController];
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
    WS(ws);
    
    NSArray* uploadIds;
    if (_assetsArray.count == 2) {
        uploadIds = [NSArray arrayWithObjects:@(_imageInfo1.imageID),@(_imageInfo2.imageID), nil];
    } else {
        uploadIds = [NSArray arrayWithObjects:@(_imageInfo1.imageID), nil];
    }
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:uploadIds forKey:@"upload_ids"];
    [param setObject:_inputTextView.text forKey:@"desc"];

    
    [DDService ddSaveAsk:param withBlock:^(NSInteger newImageID) {
        if (newImageID) {
            [Hud dismiss:self.view];
            [Hud dismiss];
            [self.view endEditing:YES];
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"shouldNavToAskSegment"];
            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSDictionary* info = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:newImageID],@"ID",[NSNumber numberWithInteger:newImageID],@"askID",@(ATOMPageTypeAsk),@"type", nil];
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
            if  (block) {
                block(NO);
            }
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [Hud error:@"求P失败,请检查你的网络"];
        }
    }];
}

- (void)uploadReplyRestInfo:(void (^) (BOOL success))block {
}

-(void)setTabBarToBeRootViewController {
    DDTabBarController *lvc = [[DDTabBarController alloc] init];
    [AppDelegate APP].window.rootViewController = lvc;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textViewDidChange");
}

-(void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"textViewDidChangeSelection");

    if (textView.text.length > 18) {
        NSString *shortString = [textView.text substringToIndex:18];
        textView.text = shortString;
    }
    _wordLimitLabel.text = [NSString stringWithFormat:@"%zd/18",_inputTextView.text.length];
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing");
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"textViewDidEndEditing");
}

@end
