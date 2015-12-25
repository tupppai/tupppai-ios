//
//  PIEFriendViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendViewController.h"
#import "DDOtherUserManager.h"
#import "PIEEntityUser.h"
#import "CAPSPageMenu.h"
#import "PIEFriendAskViewController.h"
#import "PIEFriendReplyViewController.h"
#import "PIEFriendFollowingViewController.h"
#import "PIEFriendFansViewController.h"
#import "PIECarouselViewController2.h"
#import "FXBlurView.h"
#import "PIEActionSheet_UserAbuse.h"
#import "AppDelegate.h"
#import "PIEAvatarImageView.h"

@interface PIEFriendViewController ()
//@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet PIEAvatarImageView *avatarView;

@property (weak, nonatomic) IBOutlet UIImageView *followButton;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *likedDescLabel;
@property (weak, nonatomic) IBOutlet UIView *dotView2;
@property (weak, nonatomic) IBOutlet UIView *dotView1;

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

}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSLog(@"PIEFriendViewController initWithNibName");

    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        //setup subviews here is not working,since loadView is not called,loadView is done when viewDidload is called ,put code in viewDidload.
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.hidesBarsOnSwipe = NO;
    // Do any additional setup after loading the view from its nib.
    [self setupViews];
    [self getDataSource];
    [self setupPageMenu];
    [self setupTapGesture];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    NSDictionary *titleTextAttrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                     NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttrs;
    


    
//    if (self.navigationController.viewControllers.count <= 1) {
        [self setupNavBar];
//    }
}


- (void)setupNavBar {
    UIButton *buttonLeft = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    buttonLeft.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonLeft setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    
    if (self.navigationController.viewControllers.count <= 1) {
        [buttonLeft addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [buttonLeft addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonLeft];
    self.navigationItem.leftBarButtonItem =  buttonItem;
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button2 setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(abuseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.navigationItem.rightBarButtonItem =  buttonItem2;
}
- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)abuseAction {
    PIEActionSheet_UserAbuse* actionSheet = [[PIEActionSheet_UserAbuse alloc]initWithUser:_user];
//    actionSheet.user = _user;
    if (_uid) {
        actionSheet.uid = _uid;
    } else if (_pageVM){
        actionSheet.uid = _pageVM.userID;
    }
    [actionSheet showInView:[AppDelegate APP].window animated:YES];
}
- (void)setupViews {
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _view1.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_view1.layer insertSublayer:gradient atIndex:0];

//    _avatarView.layer.cornerRadius = _avatarView.frame.size.width/2;
//    _avatarView.clipsToBounds = YES;
    _avatarView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.5];
    _dotView1.layer.cornerRadius = _dotView1.frame.size.width/2;
    _dotView2.layer.cornerRadius = _dotView2.frame.size.width/2;
    _blurView.contentMode = UIViewContentModeScaleAspectFill;
    _blurView.clipsToBounds = YES;
    
    _followButton.contentMode = UIViewContentModeCenter;

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
    if (_pageVM) {
        opvcv.uid = _pageVM.userID;
        opvcv.userName = _pageVM.username;
    } else {
        opvcv.uid = _uid;
        opvcv.userName = _name;
    }

    [self.navigationController pushViewController:opvcv animated:YES];

}
- (void)pushToFansVC {
    PIEFriendFansViewController *mfvc = [PIEFriendFansViewController new];
    if (_pageVM) {
        mfvc.uid = _pageVM.userID;
        mfvc.userName = _pageVM.username;
    } else {
        mfvc.uid = _uid;
        mfvc.userName = _name;
    }
    [self.navigationController pushViewController:mfvc animated:YES];
}


- (void)follow {
    _followButton.highlighted = !_followButton.highlighted;
    NSMutableDictionary *param = [NSMutableDictionary new];
    if (_pageVM) {
        [param setObject:@(_pageVM.userID) forKey:@"uid"];
    } else {
        [param setObject:@(_uid) forKey:@"uid"];
    }
    [DDService follow:param withBlock:^(BOOL success) {
        if (!success) {
            _followButton.highlighted = !_followButton.highlighted;
        } else {
        }
    }];
}
- (void)updateUserInterface:(PIEEntityUser*)user {
    self.title = user.nickname;
    [DDService sd_downloadImage:user.avatar withBlock:^(UIImage *image) {
        _avatarView.image = image;
        
//        _avatarView.isV = self.pageVM.isV;
        _avatarView.isV = YES;
        
        _blurView.image = [image blurredImageWithRadius:100 iterations:5 tintColor:[UIColor blackColor]];
    }];
    
    
    if (user.isMyFan) {
        _followButton.highlightedImage = [UIImage imageNamed:@"pie_mutualfollow"];
    } else {
        _followButton.highlightedImage = [UIImage imageNamed:@"new_reply_followed"];
    }
    _followButton.highlighted = user.isMyFollow;
    
    _followCountLabel.text = [NSString stringWithFormat:@"%zd",user.attentionNumber];
    _fansCountLabel.text = [NSString stringWithFormat:@"%zd",user.fansNumber];
    _likedCountLabel.text = [NSString stringWithFormat:@"%zd",user.likedCount];
    _followButton.highlighted = user.isMyFollow;
    if (user.uid == [DDUserManager currentUser].uid) {
        _followButton.hidden = YES;
    } else {
        _followButton.hidden = NO;
    }
}

- (void)setupPageMenu {
    NSMutableArray *controllerArray = [NSMutableArray array];
    
    PIEFriendReplyViewController *controller2 = [PIEFriendReplyViewController new];
    controller2.title = @"作品";
    PIEFriendAskViewController *controller = [PIEFriendAskViewController new];
    controller.title = @"ta的求P";

    if (_pageVM) {
        controller.pageVM = _pageVM;
        controller2.pageVM = _pageVM;
    } else {
        controller.uid = _uid;
        controller2.uid = _uid;
    }
    
    [controllerArray addObject:controller2];
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
//    (0, _view1.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _view1.frame.size.height)
   _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0, 0, SCREEN_WIDTH, 100) options:parameters];
    _pageMenu.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _pageMenu.view.layer.borderColor = [UIColor colorWithHex:0x000000 andAlpha:0.1].CGColor;
    _pageMenu.view.layer.borderWidth = 0.5;
    [self.view addSubview:_pageMenu.view];
    [_pageMenu.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view1.mas_bottom).with.priorityHigh();
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
//    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
//    [_pageMenu.view addGestureRecognizer:panGesture];
}
//- (void)panGesture:(UIPanGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        _startPanLocationY = [sender locationInView:self.view].y;
//    }
//    if (_pageMenu.view.frame.origin.y >= 0 && _pageMenu.view.frame.origin.y <= 180) {
//        
//        CGFloat dif = [sender locationInView:self.view].y - _startPanLocationY;
//        CGFloat y = _pageMenu.view.frame.origin.y +  dif ;
//        y = MIN(y, 180);
//        y = MAX(y, 0);
//        _pageMenu.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-NAV_HEIGHT-y);
//        _startPanLocationY = [sender locationInView:self.view].y;
//    }
//}

- (void)scrollUp {

    if (_pageMenu.view.frame.origin.y != 0) {
        [self.pageMenu.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view1.mas_bottom).with.offset(-self.view1.frame.size.height+NAV_HEIGHT).with.priorityHigh();
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self.pageMenu.view layoutIfNeeded];
        }];
    }
}
- (void)scrollDown {
    if (_pageMenu.view.frame.origin.y != self.view1.frame.size.height) {
        [self.pageMenu.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view1.mas_bottom).with.offset(0).with.priorityHigh();
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self.pageMenu.view layoutIfNeeded];
        }];
    }
}

#pragma mark - GetDataSource
- (void)getDataSource {
    //目前的接口是ask和reply一起返回
//    WS(ws);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    long long timeStamp = [[NSDate date] timeIntervalSince1970];
    if (_pageVM) {
        [param setObject:@(_pageVM.userID) forKey:@"uid"];
    } else {
        [param setObject:@(_uid) forKey:@"uid"];
    }
    [param setObject:@(SCREEN_WIDTH) forKey:@"width"];
    [param setObject:@(timeStamp) forKey:@"last_updated"];
    
    [DDOtherUserManager getUserInfo:param withBlock:^(PIEEntityUser *user) {
        if (user) {
            [self updateUserInterface:user];
            _user = user;
        }
    }];
}




@end
