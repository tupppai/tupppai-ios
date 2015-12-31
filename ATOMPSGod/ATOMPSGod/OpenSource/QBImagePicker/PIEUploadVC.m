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
#import "PIEModelImageInfo.h"
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

@property (nonatomic, strong) PIEModelImageInfo *imageInfo1;
@property (nonatomic, strong) PIEModelImageInfo *imageInfo2;

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
    if ([PIEUploadManager shareModel].type == PIEPageTypeAsk) {
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
    if ([PIEUploadManager shareModel].type == PIEPageTypeReply) {
        _inputTextView.placeholder = @"输入你想对观众说的吧";
    } else  {
        _inputTextView.placeholder = @"写下你的图片需求吧";
    }
    _inputTextView.delegate = self;
    _leftImageView.clipsToBounds = YES;
    _rightImageView.clipsToBounds = YES;
    
    if (_hideSecondView) {
        _rightImageView.hidden = YES;
    }
    
    [self setupData];
}

- (void)setupData {
    
    _uploadInfo = [NSMutableDictionary new];
    
//    if (_channelVM) {
//        [PIEUploadManager shareModel].channel_id = _channelVM.ID;
//        [_uploadInfo setObject:@(_channelVM.ID) forKey:@"channel_id"];
//    }
//    
//    
    if (_assetsArray.count == 1) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [UIImage imageNamed:@"pie_upload_plus"];
        UITapGestureRecognizer* tapGesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iWantSelecteMorePhoto)];
        _rightImageView.userInteractionEnabled = YES;
        [_rightImageView addGestureRecognizer:tapGesure];
        [_uploadInfo setObject:(_leftImageView.image) forKey:@"image1"];
        [_uploadInfo setObject:@1 forKey:@"imageCount"];
        [[PIEUploadManager shareModel].imageArray addObject:_leftImageView.image];

        
    } else if (_assetsArray.count == 2) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:1] type:ASSET_PHOTO_SCREEN_SIZE];
        [_uploadInfo setObject:(_leftImageView.image) forKey:@"image1"];
        [_uploadInfo setObject:(_rightImageView.image) forKey:@"image2"];
        [_uploadInfo setObject:@2 forKey:@"imageCount"];
        
        [[PIEUploadManager shareModel].imageArray addObject:_leftImageView.image];
        [[PIEUploadManager shareModel].imageArray addObject:_rightImageView.image];
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
    else if ([PIEUploadManager shareModel].type == PIEPageTypeAsk&& _succeedToDownloadTags && _view_tag.array_selectedId.count<=0 ) {
        [self showWarnLabel2];
    } else {
        if (([PIEUploadManager shareModel].type == PIEPageTypeAsk)) {
            [_uploadInfo setObject:@"ask" forKey:@"type"];
            [PIEUploadManager shareModel].type = PIEPageTypeAsk;
        } else if ([PIEUploadManager shareModel].type == PIEPageTypeReply) {
            [_uploadInfo setObject:@"reply" forKey:@"type"];
            
            [PIEUploadManager shareModel].type = PIEPageTypeReply;
        }
        [PIEUploadManager shareModel].tagIDArray = _view_tag.array_selectedId;
        [PIEUploadManager shareModel].content = _inputTextView.text;

        [_uploadInfo setObject:_view_tag.array_selectedId forKey:@"tag_ids_array"];
        [_uploadInfo setObject:_inputTextView.text forKey:@"text_string"];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"UploadCall" object:nil userInfo:_uploadInfo];
        
        [self.inputTextView resignFirstResponder];
        [self backToTabbarController];
    }
}

- (void)backToTabbarController {
    PIETabBarController *lvc = [AppDelegate APP].mainTabBarController;
    [lvc dismissViewControllerAnimated:YES completion:nil];
    [lvc.selectedViewController popToRootViewControllerAnimated:YES];
//    [lvc setSelectedIndex:1];
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
    if (([PIEUploadManager shareModel].type == PIEPageTypeAsk)) {
        [Hud text:@"输入你需要的效果吧"];
    } else if ([PIEUploadManager shareModel].type == PIEPageTypeReply) {
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
