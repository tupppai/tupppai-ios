//
//  PIEUploadVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/10/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEUploadVC.h"
#import "SZTextView.h"
#import "PIEUploadManager.h"
#import "DDNavigationController.h"
#import "AppDelegate.h"
#import "DDTabBarController.h"
@interface PIEUploadVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet SZTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *wordLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftShareButton;
@property (weak, nonatomic) IBOutlet UIButton *rightShareButton;

@property (strong, nonatomic)  PIEUploadManager *uploadManager;

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
    _uploadManager = [PIEUploadManager new];
    if (_assetsArray.count == 1) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [UIImage imageNamed:@"plus_sign"];
        NSData *data = UIImageJPEGRepresentation(_leftImageView.image, 1.0);
        NSArray* array = [NSArray arrayWithObject:data];
        _uploadManager.imageDataArray = array;
    } else if (_assetsArray.count == 2) {
        _leftImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:0] type:ASSET_PHOTO_SCREEN_SIZE];
        _rightImageView.image = [Util getImageFromAsset:[_assetsArray objectAtIndex:1] type:ASSET_PHOTO_SCREEN_SIZE];
        NSData *data = UIImageJPEGRepresentation(_leftImageView.image, 1.0);
        NSData *data2 = UIImageJPEGRepresentation(_rightImageView.image, 1.0);
        NSArray* array = [NSArray arrayWithObjects:data,data2,nil];
        _uploadManager.imageDataArray = array;
    }
}
-(void) tapNext {
    NSLog(@"tapNext %zd",_inputTextView.text.length);
    if (_inputTextView.text.length == 0) {
            [self showWarnLabel];
    } else {
        _uploadManager.text = _inputTextView.text;
        [[NSUserDefaults standardUserDefaults]setObject:_uploadManager forKey:@"UploadManager"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.viewControllers = @[];
            DDTabBarController *lvc = [[DDTabBarController alloc] init];
            [AppDelegate APP].window.rootViewController = lvc;
        }];
    }

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
