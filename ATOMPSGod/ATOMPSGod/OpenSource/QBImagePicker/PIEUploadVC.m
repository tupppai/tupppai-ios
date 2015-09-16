//
//  PIEUploadVC.m
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/10/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEUploadVC.h"
#import "SZTextView.h"

@interface PIEUploadVC ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet SZTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *wordLimitLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftShareButton;
@property (weak, nonatomic) IBOutlet UIButton *rightShareButton;

@end

@implementation PIEUploadVC

-(BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor =[UIColor darkGrayColor];
}
-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor =[UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* itemView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    itemView.image = [UIImage imageNamed:@"pie_publish"];
    itemView.contentMode = UIViewContentModeScaleAspectFit;
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    self.navigationItem.rightBarButtonItem = item;
    
    _leftImageView.clipsToBounds = YES;
    _rightImageView.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
    if (_imageArray.count == 1) {
        _leftImageView.image = [_imageArray objectAtIndex:0];
        _rightImageView.image = [UIImage imageNamed:@"plus_sign"];
    } else if (_imageArray.count == 2) {
        _leftImageView.image = [_imageArray objectAtIndex:0];
        _rightImageView.image = [_imageArray objectAtIndex:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
