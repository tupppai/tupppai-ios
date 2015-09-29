//
//  PIEFriendViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendViewController.h"
#import "DDOtherUserManager.h"
#import "ATOMUser.h"
#import "CAPSPageMenu.h"
#import "PIEFriendReplyViewController.h"
#import "PIEFriendAskViewController.h"
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@interface PIEFriendViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *followButton;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedDescLabel;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation PIEFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getDataSource];
    [self setupPageMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateUserInterface:(ATOMUser*)user {
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    [_avatarView setImageWithURL:[NSURL URLWithString:user.avatar]];
    _followCountLabel.text = [NSString stringWithFormat:@"%zd",user.attentionNumber];
    _fansCountLabel.text = [NSString stringWithFormat:@"%zd",user.fansNumber];
    _likedCountLabel.text = [NSString stringWithFormat:@"%zd",user.likeNumber];
}


- (void)setupPageMenu {
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    PIEFriendReplyViewController *controller2 = [PIEFriendReplyViewController new];
    controller2.title = @"求P";
    controller2.pageVM = _pageVM;
    [controllerArray addObject:controller2];

    PIEFriendReplyViewController *controller = [PIEFriendReplyViewController new];
    controller.pageVM = _pageVM;
    controller.title = @"作品";
    [controllerArray addObject:controller];
    
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithHex:PIEColorHex],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:0.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont systemFontOfSize:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(SCREEN_WIDTH/2 - 5),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor blackColor],
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(YES)
                                 };
    
   _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0, _view1.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _view1.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
}


#pragma mark - GetDataSource
- (void)getDataSource {
    //目前的接口是ask和reply一起返回
//    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
//    [param setObject:@(15) forKey:@"size"];
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];

    [DDOtherUserManager getOtherUserInfo:param withBlock:^(ATOMUser *user) {
        if (user) {
            [self updateUserInterface:user];
        }
    }];
}




@end
