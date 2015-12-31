//
//  PIEFriendViewController.m
//  TUPAI
//
//  Created by chenpeiwei on 9/29/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEFriendViewController.h"
#import "DDOtherUserManager.h"
#import "PIEUserModel.h"
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
#import "PIEAvatarView.h"
#import "UINavigationBar+Awesome.h"

@interface PIEFriendViewController ()

@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *psGodCertificateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *psGodIcon_big;

//@property (weak, nonatomic) IBOutlet UIImageView *followButton;
@property (weak, nonatomic) UIButton *followButton;
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


@property (weak, nonatomic) UIButton *nav_back_button;
@property (weak, nonatomic) UIButton *nav_more_button;
@property (weak, nonatomic) UIButton *nav_follow_button;



@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation PIEFriendViewController

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}
-(void)awakeFromNib {

}

#pragma mark - UI life cycles
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.navigationController.hidesBarsOnSwipe = NO;
    
    [self setupViews];
    [self getDataSource];
    [self setupPageMenu];
    [self setupTapGesture];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    NSDictionary *titleTextAttrs = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.navigationController.navigationBar.titleTextAttributes = titleTextAttrs;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    [self setupNavBar];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // set the navigationBar back to the default style --- thus leaving no side-effects
    [self.navigationController.navigationBar lt_reset];
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
    self.nav_back_button = buttonLeft;
    
    
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button2 setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(abuseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.nav_more_button = button2;
    
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    button3.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [button3 setImage:[UIImage imageNamed:@"navigationbar_addFollow"]
             forState:UIControlStateNormal];
    
    [button3 addTarget:self action:@selector(follow)
      forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *buttonItem3 = [[UIBarButtonItem alloc] initWithCustomView:button3];
    self.navigationItem.rightBarButtonItems = @[buttonItem2, buttonItem3];
    self.followButton = button3;
    
    
}



#pragma mark - target actions
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
    self.nameLabel.font = [UIFont mediumTupaiFontOfSize:17];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _view1.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_view1.layer insertSublayer:gradient atIndex:0];
    
    self.avatarView.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarView.avatarImageView.layer.borderWidth = 1.5f;
    
    _dotView1.layer.cornerRadius = _dotView1.frame.size.width/2;
    _dotView2.layer.cornerRadius = _dotView2.frame.size.width/2;
    _blurView.contentMode = UIViewContentModeScaleAspectFill;
    _blurView.clipsToBounds = YES;
    

}
- (void)setupTapGesture {
    _followCountLabel.userInteractionEnabled = YES;
    _followDescLabel.userInteractionEnabled  = YES;
    _fansCountLabel.userInteractionEnabled   = YES;
    _fansDescLabel.userInteractionEnabled    = YES;

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
    
    _user.isMyFollow = !_user.isMyFollow;

    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(_user.uid) forKey:@"uid"];
    NSNumber *status = _user.isMyFollow ? @1:@0;
    [param setObject:status forKey:@"status"];
    
    [DDService follow:param withBlock:^(BOOL success) {
        if (success) {
            _pageVM.followed = _user.isMyFollow;
        } else {
            _user.isMyFollow = !_user.isMyFollow;
        }
    }];
}
- (void)updateUserInterface:(PIEUserModel*)user {
//    self.title = user.nickname;
    
    self.nameLabel.text = user.nickname;
    
    

    self.psGodIcon_big.hidden             = !user.isV;
    self.psGodCertificateImageView.hidden = !user.isV;
    
    NSString* avatarUrlString = [user.avatar trimToImageWidth:_avatarView.frame.size.width*2];
    [DDService sd_downloadImage:avatarUrlString withBlock:^(UIImage *image) {
        _avatarView.avatarImageView.image = image;
        
    //testing...done
        
    _blurView.image = [image blurredImageWithRadius:100 iterations:5 tintColor:[UIColor blackColor]];
    }];
    
    
    if (user.isMyFan) {
        [self.followButton setImage:[UIImage imageNamed:@"navigationbar_mutualFollow"]
                 forState:UIControlStateSelected];
    }else{
        [self.followButton setImage:[UIImage imageNamed:@"navigationbar_followed"]
                 forState:UIControlStateSelected];
    }
    
    
    self.followButton.selected = user.isMyFollow;
    _followCountLabel.text     = [NSString stringWithFormat:@"%zd",user.attentionNumber];
    _fansCountLabel.text       = [NSString stringWithFormat:@"%zd",user.fansNumber];
    _likedCountLabel.text      = [NSString stringWithFormat:@"%zd",user.likedCount];

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
    _pageMenu.view.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
    _pageMenu.view.layer.borderColor = [UIColor colorWithHex:0x000000 andAlpha:0.1].CGColor;
    _pageMenu.view.layer.borderWidth = 0.5;
    [self.view addSubview:_pageMenu.view];
    [_pageMenu.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view1.mas_bottom).with.priorityHigh();
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];

}


- (void)scrollUp {

    if (_pageMenu.view.frame.origin.y != 0) {
        [self.pageMenu.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view1.mas_bottom).with.offset(-self.view1.frame.size.height+NAV_HEIGHT).with.priorityHigh();
        }];
        [UIView animateWithDuration:0.5 animations:^{
            [self.pageMenu.view layoutIfNeeded];
            
            // GOD DAMN USEFUL PIECE OF CODES!
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
            self.navigationItem.title = _pageVM.username;
            [self.nav_back_button setImage:[UIImage imageNamed:@"nav_back_black"]
                                  forState:UIControlStateNormal];
            [self.nav_more_button setImage:[UIImage imageNamed:@"nav_more_black"]
                                  forState:UIControlStateNormal];
            [self.followButton setImage:[UIImage imageNamed:@"navigationbar_addFollow_black"]
                               forState:UIControlStateNormal];
            if (_user.isMyFan) {
                [self.followButton setImage:[UIImage imageNamed:@"navigationbar_mutualFollow_black"]
                                   forState:UIControlStateSelected];
            }else{
                [self.followButton setImage:[UIImage imageNamed:@"navigationbar_followed_black"]
                                   forState:UIControlStateSelected];
            }
            
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
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
            self.navigationItem.title = @"";
            [self.nav_back_button setImage:[UIImage imageNamed:@"nav_back"]
                                  forState:UIControlStateNormal];
            [self.nav_more_button setImage:[UIImage imageNamed:@"nav_more"]
                                  forState:UIControlStateNormal];
            
            [self.followButton setImage:[UIImage imageNamed:@"navigationbar_addFollow"]
                               forState:UIControlStateNormal];
            if (_user.isMyFan) {
                [self.followButton setImage:[UIImage imageNamed:@"navigationbar_mutualFollow"]
                                   forState:UIControlStateSelected];
            }else{
                [self.followButton setImage:[UIImage imageNamed:@"navigationbar_followed"]                                   forState:UIControlStateSelected];
            }
            
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
    
    [DDOtherUserManager getUserInfo:param withBlock:^(PIEUserModel *user) {
        if (user) {
            [self updateUserInterface:user];
            _user = user;
            [self addKVOTo:_user];
        }
    }];
}


-(void)dealloc {
    [self removeKVOFrom:_user];
}
- (void)addKVOTo:(id)receive{
    [receive addObserver:self forKeyPath:@"isMyFollow" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)removeKVOFrom:(id)receiver {
    @try{
        [receiver removeObserver:self forKeyPath:@"isMyFollow"];
    }@catch(id anException){
        //do nothing, obviously it wasn't attached because an exception was thrown
    }
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"isMyFollow"]) {
        BOOL newFollowed = [[change objectForKey:@"new"]boolValue];
        self.followButton.selected = newFollowed;
    }
    
}

@end
