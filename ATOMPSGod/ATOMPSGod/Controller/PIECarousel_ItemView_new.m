//
//  PIECarousel_ItemView_new.m
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/23/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIECarousel_ItemView_new.h"
#import "PIEAvatarView.h"
#import "PIEBlurAnimateImageView.h"
#import "PIELoveButton.h"
#import "PIEFriendViewController.h"
#import "DDNavigationController.h"
#import "PIEPageDetailViewController.h"
#import "PIEActionSheet_PS.h"


@interface PIECarousel_ItemView_new ()

@property (nonatomic, strong) PIEPageVM *currentPageVM;

@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *downloadButtonTrailingConstraint;

@property (nonatomic, strong) PIEActionSheet_PS *psActionSheet;

@end

@implementation PIECarousel_ItemView_new

#pragma mark - UI components setup

+ (PIECarousel_ItemView_new *)itemView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PIECarousel_ItemView_new"
                                          owner:nil options:nil] lastObject];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self commonInit];
    
    [self setupTouchingEvents];
}

- (void)commonInit
{
    [self.downloadButton setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
                                   forState:UIControlStateNormal];
    
    [self.detailButton setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground"]
                                 forState:UIControlStateNormal];
    
    self.blurAnimateImageView.hideThumbView = YES;

}

- (void)setupTouchingEvents
{
    UITapGestureRecognizer *tapOnAvatar =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(tapOnUser)];
    [self.avatarView addGestureRecognizer:tapOnAvatar];
    self.avatarView.userInteractionEnabled = YES;
    self.avatarView.avatarImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapOnUsernameLabel =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapOnUser)];
    [self.usernameLabel addGestureRecognizer:tapOnUsernameLabel];
    self.usernameLabel.userInteractionEnabled = YES;
    
    [self.downloadButton addTarget:self
                            action:@selector(downloadImage)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailButton addTarget:self
                          action:@selector(pushToCommentVC)
                forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapOnLoveButton =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnLoveButton)];
    [self.loveButton addGestureRecognizer:tapOnLoveButton];
    self.loveButton.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longPressOnLoveButton =
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(longPressOnLoveButton)];
    [self.loveButton addGestureRecognizer:longPressOnLoveButton];


}

#pragma mark -
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error
  contextInfo: (void *) contextInfo {
    
    [Hud dismiss];
    if(error != nil || image == nil){
        [Hud customText:@"保存出错" inView:[AppDelegate APP].window];
    } else {
        [Hud customText:@"作品保存成功" inView:[AppDelegate APP].window];
    }
}


#pragma mark - Touching event responses
- (void)tapOnUser
{
    PIEFriendViewController *friendVC =
    [PIEFriendViewController new];
    
    friendVC.pageVM = _currentPageVM;
    friendVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    
    DDNavigationController *nav = [[DDNavigationController alloc] initWithRootViewController:friendVC];
    
    [self.viewController presentViewController:nav
                                      animated:YES
                                    completion:nil];
    
}


/**
    新需求：
    ASK-> “帮P”，弹Actionsheet
    Reply -> "保存"， 直接下载图片到沙盒
 
    因为名字太难改了，所以downloadButton，downloadImage这些名字保持原来一致(就是信不过xcode的refactor）
 */
- (void)downloadImage
{
    if (_currentPageVM.type == PIEPageTypeAsk) {
        self.psActionSheet.vm = _currentPageVM;
        [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
    }else{
        // 保存到沙盒
        [Hud activity:@"保存中..."];
        [DDService sd_downloadImage:_currentPageVM.model.imageURL withBlock:^(UIImage *image) {
        
            UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }];
        
    }
    
}

- (void)pushToCommentVC
{
    PIEPageDetailViewController *pageDetailVC =
    [[PIEPageDetailViewController alloc] init];
    
    pageDetailVC.pageViewModel = _currentPageVM;
    
    pageDetailVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    DDNavigationController *nav =
    [[DDNavigationController alloc] initWithRootViewController:pageDetailVC];
    
    [self.viewController presentViewController:nav
                                      animated:YES completion:nil];
}

- (void)tapOnLoveButton
{
    [_currentPageVM love:NO];
    
    self.loveButton.status = _currentPageVM.loveStatus;
    self.loveButton.numberString = _currentPageVM.likeCount;
}

- (void)longPressOnLoveButton
{
    [_currentPageVM love:YES];
    
    self.loveButton.status = _currentPageVM.loveStatus;
    self.loveButton.numberString = _currentPageVM.likeCount;
}

//- (void)tapOnBang
//{
//    self.psActionSheet.vm = _currentPageVM;
//    [self.psActionSheet showInView:[AppDelegate APP].window animated:YES];
//}

#pragma mark - public methods
- (void)injectPageVM:(PIEPageVM *)pageVM
{
    // 赋值
    self.currentPageVM = pageVM;
    
    // UI元素的预处理
    if (pageVM.type == PIEPageTypeAsk) {
        self.askIconImageView.hidden   = NO;
        self.replyIconImageView.hidden = YES;
        self.loveButton.hidden         = YES;
        [self.downloadButton setTitle:@"帮P" forState:UIControlStateNormal];
        
    }else if (pageVM.type == PIEPageTypeReply){
        self.askIconImageView.hidden   = YES;
        self.replyIconImageView.hidden = NO;
        self.loveButton.hidden         = NO;
        [self.downloadButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    
    // 头像
    self.avatarView.url =
    [pageVM.avatarURL trimToImageWidth:self.avatarView.frame.size.width * SCREEN_SCALE];
    self.avatarView.isV = pageVM.isV;
    
    // 用户名
    self.usernameLabel.text             = pageVM.username;
    
    // 时间
    self.createdTimeLabel.text          = pageVM.publishTime;
    
    // 图像
    self.blurAnimateImageView.viewModel = pageVM;
    
    // RAC-binding
    
    // --- 1. dispose previous subscription, since the view might be reused.
//    [self.previousLoveStatusSubscriptionDisposable dispose];
//    [self.previousNumberStringSubscriptionDisposable dispose];
//    
    // --- 2. binding & re-assign disposables
//    @weakify(self);
//    self.previousLoveStatusSubscriptionDisposable =
//    [RACObserve(pageVM, loveStatus)
//     subscribeNext:^(NSNumber *enumValue) {
//         @strongify(self);
//         self.loveButton.status = [enumValue integerValue];
//     }];
//    self.previousNumberStringSubscriptionDisposable =
//    [RACObserve(pageVM, likeCount)
//     subscribeNext:^(NSString *numberString) {
//         @strongify(self);
//         self.loveButton.numberString = numberString;
//     }];
    
    // 超级赞
    self.loveButton.status       = pageVM.loveStatus;
    self.loveButton.numberString = pageVM.likeCount;
    
    [self addRoundedCorner];
}


- (void)setShouldHideDetailButton:(BOOL)shouldHideDetailButton
{
    if (shouldHideDetailButton) {
        self.detailButton.hidden = YES;

        self.downloadButtonTrailingConstraint.constant = self.downloadButton.frame.size.width/2.0;

        [self layoutIfNeeded];
        
    }else{
        self.detailButton.hidden = NO;
        
        self.downloadButtonTrailingConstraint.constant = -5;
        
        [self layoutIfNeeded];
    }
}

#pragma mark - private helpers
- (void)addRoundedCorner
{
        CAShapeLayer * maskLayer = [CAShapeLayer layer];
        maskLayer.path =
        [UIBezierPath
         bezierPathWithRoundedRect:self.bounds
         byRoundingCorners: UIRectCornerAllCorners
         cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    
        self.layer.mask = maskLayer;
}


#pragma mark - Lazy loadings
- (PIEActionSheet_PS *)psActionSheet
{
    if (_psActionSheet == nil) {
        _psActionSheet    = [PIEActionSheet_PS new];
    }
    return  _psActionSheet;
}

@end
