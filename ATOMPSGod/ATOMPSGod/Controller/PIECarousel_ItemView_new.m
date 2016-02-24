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

@interface PIECarousel_ItemView_new ()

@property (nonatomic, strong) PIEPageVM *currentPageVM;

@property (nonatomic, strong) RACDisposable *previousLoveStatusSubscriptionDisposable;
@property (nonatomic, strong) RACDisposable *previousNumberStringSubscriptionDisposable;

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

#pragma mark - Touching event responses
- (void)tapOnUser
{
    [Hud text:[@(self.currentPageVM.ID) stringValue]];
}

- (void)downloadImage
{
    [Hud text:[@(self.currentPageVM.ID) stringValue]];
}

- (void)pushToCommentVC
{
   [Hud text:[@(self.currentPageVM.ID) stringValue]];
}

- (void)tapOnLoveButton
{
   [Hud text:[@(self.currentPageVM.ID) stringValue]];
}

- (void)longPressOnLoveButton
{
   [Hud text:[@(self.currentPageVM.ID) stringValue]];
}


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
        self.bangIconImageView.hidden  = NO;
        
    }else if (pageVM.type == PIEPageTypeReply){
        self.askIconImageView.hidden   = YES;
        self.replyIconImageView.hidden = NO;
        self.loveButton.hidden         = NO;
        self.bangIconImageView.hidden  = YES;
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
    [self.previousLoveStatusSubscriptionDisposable dispose];
    [self.previousNumberStringSubscriptionDisposable dispose];
    
    // --- 2. binding & re-assign disposables
    @weakify(self);
    self.previousLoveStatusSubscriptionDisposable =
    [RACObserve(pageVM, loveStatus)
     subscribeNext:^(NSNumber *enumValue) {
         @strongify(self);
         self.loveButton.status = [enumValue integerValue];
     }];
    self.previousNumberStringSubscriptionDisposable =
    [RACObserve(pageVM, likeCount)
     subscribeNext:^(NSString *numberString) {
         @strongify(self);
         self.loveButton.numberString = numberString;
     }];
    
    [self addRoundedCorner];
}


- (void)setShouldHideDetailButton:(BOOL)shouldHideDetailButton
{
    if (shouldHideDetailButton) {
        self.detailButton.hidden = YES;
        
        @weakify(self);
        [self.downloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self).with.offset(0);
        }];
        
        [self.downloadButton layoutIfNeeded];
        
    }else{
        self.detailButton.hidden = NO;
        
        @weakify(self);
        [self.downloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self).with.offset(-50);
        }];
        
        [self.downloadButton layoutIfNeeded];
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

@end
