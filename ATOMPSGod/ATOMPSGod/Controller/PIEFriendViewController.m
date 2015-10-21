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
#import "PIEFriendAskViewController.h"
#import "PIEFriendReplyViewController.h"
#import "PIEFriendFollowingViewController.h"
#import "PIEFriendFansViewController.h"
#import "PIECarouselViewController.h"
#import "FXBlurView.h"
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
@property (nonatomic,assign) CGFloat startPanLocationY;
@property (weak, nonatomic) IBOutlet UIImageView *blurView;


@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation PIEFriendViewController

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)awakeFromNib {
    NSLog(@"PIEFriendViewController awakeFromNib");

}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"PIEFriendViewController initWithNibName");


    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@" PIEFriendViewController initWithCoder");
        //setup subviews here is not working,since loadView is not called,loadView is done when viewDidload is called ,put code in viewDidload.
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupViews];
    [self getDataSource];
    [self setupPageMenu];
    [self setupTapGesture];
}
- (void)setupViews {
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
    _avatarView.clipsToBounds = YES;
    _avatarView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    
    _followCountLabel.textColor = [UIColor colorWithHex:0x4A4A4A andAlpha:1.0];
    _fansCountLabel.textColor = [UIColor colorWithHex:0x4A4A4A andAlpha:1.0];
    _likedCountLabel.textColor = [UIColor colorWithHex:0x4A4A4A andAlpha:1.0];

    _followCountLabel.font = [UIFont boldSystemFontOfSize:15];
    _fansCountLabel.font = [UIFont boldSystemFontOfSize:15];
    _likedCountLabel.font = [UIFont boldSystemFontOfSize:15];
//    
    _fansDescLabel.font = [UIFont systemFontOfSize:14];
    _followCountLabel.font = [UIFont systemFontOfSize:14];
    _likedDescLabel.font = [UIFont systemFontOfSize:14];
    _blurView.contentMode = UIViewContentModeScaleAspectFill;
    _blurView.clipsToBounds = YES;

}
- (void)setupTapGesture {
    _followButton.userInteractionEnabled = YES;
    _followCountLabel.userInteractionEnabled = YES;
    _followDescLabel.userInteractionEnabled = YES;
    _fansCountLabel.userInteractionEnabled = YES;
    _fansDescLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapG1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(follow)];
    [_followButton addGestureRecognizer:tapG1];
    UITapGestureRecognizer *tapG2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFollowingVC)];
    UITapGestureRecognizer *tapG22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFollowingVC)];
    
    [_followCountLabel addGestureRecognizer:tapG2];
    [_followDescLabel addGestureRecognizer:tapG22];
    UITapGestureRecognizer *tapG3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFansVC)];
    UITapGestureRecognizer *tapG33 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFansVC)];
    [_fansCountLabel addGestureRecognizer:tapG3];
    [_fansDescLabel addGestureRecognizer:tapG33];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollUp)
                                                 name:@"PIEFriendScrollUp"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollDown)
                                                 name:@"PIEFriendScrollDown"
                                               object:nil];
    
}

- (void)pushToFollowingVC {
    PIEFriendFollowingViewController *opvcv = [PIEFriendFollowingViewController new];
    opvcv.uid = _pageVM.userID;
    opvcv.userName = _pageVM.username;
    [self.navigationController pushViewController:opvcv animated:YES];

}
- (void)pushToFansVC {
    PIEFriendFansViewController *mfvc = [PIEFriendFansViewController new];
    mfvc.uid = _pageVM.userID;
    mfvc.userName = _pageVM.username;
    [self.navigationController pushViewController:mfvc animated:YES];
}


- (void)follow {
    _followButton.highlighted = !_followButton.highlighted;
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_pageVM.userID) forKey:@"uid"];
    [DDService follow:param withBlock:^(BOOL success) {
        if (!success) {
            _followButton.highlighted = !_followButton.highlighted;
        } else {
        }
    }];
}
- (void)updateUserInterface:(ATOMUser*)user {
    self.title = user.nickname;
    [_avatarView setImageWithURL:[NSURL URLWithString:user.avatar]];
    _followCountLabel.text = [NSString stringWithFormat:@"%zd",user.attentionNumber];
    _fansCountLabel.text = [NSString stringWithFormat:@"%zd",user.fansNumber];
    _likedCountLabel.text = [NSString stringWithFormat:@"%zd",user.likeNumber];
    _followButton.highlighted = user.isMyFollow;
}

- (void)setupPageMenu {
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    PIEFriendReplyViewController *controller2 = [PIEFriendReplyViewController new];
    controller2.title = @"作品";
    controller2.pageVM = _pageVM;
    [controllerArray addObject:controller2];
    
    PIEFriendAskViewController *controller = [PIEFriendAskViewController new];
    controller.pageVM = _pageVM;
    controller.title = @"ta的求P";
    [controllerArray addObject:controller];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor pieYellowColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:0.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont boldSystemFontOfSize:14],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: [UIColor blackColor],
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl:@(YES),
                                 CAPSPageMenuOptionSelectionIndicatorWidth:@66,
                                 };
   _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0, _view1.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _view1.frame.size.height) options:parameters];
    _pageMenu.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_pageMenu.view];
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [_pageMenu.view addGestureRecognizer:panGesture];
}
- (void)panGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _startPanLocationY = [sender locationInView:self.view].y;
    }
    if (_pageMenu.view.frame.origin.y >= 0 && _pageMenu.view.frame.origin.y <= 180) {
        
        CGFloat dif = [sender locationInView:self.view].y - _startPanLocationY;
        CGFloat y = _pageMenu.view.frame.origin.y +  dif ;
        y = MIN(y, 180);
        y = MAX(y, 0);
        
        _pageMenu.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT);
        _startPanLocationY = [sender locationInView:self.view].y;

    }
}

- (void)scrollUp {
    if (_pageMenu.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            _pageMenu.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
    
}
- (void)scrollDown {
    if (_pageMenu.view.frame.origin.y != 180) {
        [UIView animateWithDuration:0.5 animations:^{
            _pageMenu.view.frame = CGRectMake(0, 180, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
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
            _blurView.image = [_avatarView.image blurredImageWithRadius:40 iterations:1 tintColor:nil];
            
        }
    }];
    
}




@end
