////
////  PIEImageDetailView.m
////  TUPAI
////
////  Created by TUPAI-Huangwei on 2/23/16.
////  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
////
//
//#import "PIEImageDetailPanelView.h"
//#import "PIEAvatarView.h"
//#import "PIEBlurAnimateImageView.h"
//#import "PIELoveButton.h"
//
//@interface PIEImageDetailPanelView ()
//
//@property (weak, nonatomic) IBOutlet PIEAvatarView           *avatarView;
//@property (weak, nonatomic) IBOutlet UILabel                 *usernameLabel;
//@property (weak, nonatomic) IBOutlet UILabel                 *createdTimeLabel;
//@property (weak, nonatomic) IBOutlet UIImageView             *askIconImageView;
//@property (weak, nonatomic) IBOutlet UIImageView             *replyIconImageView;
//@property (weak, nonatomic) IBOutlet PIEBlurAnimateImageView *blurAnimateImageView;
//@property (weak, nonatomic) IBOutlet UIButton                *downloadButton;
//@property (weak, nonatomic) IBOutlet UIButton                *detailButton;
//@property (weak, nonatomic) IBOutlet PIELoveButton           *loveButton;
//@property (weak, nonatomic) IBOutlet UIImageView             *bangImageView;
//
//@end
//
//@implementation PIEImageDetailView
//
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    
//    [self commonInit];
//    
//}
//
//- (void)commonInit
//{
//    [self.downloadButton
//     setBackgroundImage:[UIImage imageNamed:@"pie_myWallet_chargeButton"]
//     forState:UIControlStateNormal];
//    
//    [self.detailButton
//     setBackgroundImage:[UIImage imageNamed:@"launchViewControllerButtonBackground"]
//     forState:UIControlStateNormal];
//    
//}
//
//#pragma mark - public methods
//
//- (void)injectVM:(PIEPageVM *)pageVM
//{
//    // 相关UI元素的预处理
//    if (pageVM.type == PIEPageTypeAsk)
//    {
//        self.askIconImageView.hidden   = NO;
//        self.replyIconImageView.hidden = YES;
//        self.bangImageView.hidden      = NO;
//        self.loveButton.hidden         = YES;
//    }else if (pageVM.type == PIEPageTypeReply)
//    {
//        self.askIconImageView.hidden   = YES;
//        self.replyIconImageView.hidden = NO;
//        self.bangImageView.hidden      = YES;
//        self.loveButton.hidden         = NO;
//    }
//    
//    // 头像
//    self.avatarView.url =
//    [pageVM.avatarURL trimToImageWidth:self.avatarView.frame.size.width * SCREEN_SCALE];
//    self.avatarView.isV = pageVM.isV;
//    
//    // 用户名
//    self.usernameLabel.text             = pageVM.username;
//
//    // 日期
//    self.createdTimeLabel.text          = pageVM.publishTime;
//
//    // 图片
//    self.blurAnimateImageView.viewModel = pageVM;
//    
//    // LOVE button
//    if (pageVM.type == PIEPageTypeReply) {
//        RAC(self.loveButton, status)       = [RACObserve(pageVM, loveStatus)
//                                              takeUntil:self.rac_willDeallocSignal];
//        RAC(self.loveButton, numberString) = [RACObserve(pageVM, likeCount)
//                                              takeUntil:self.rac_willDeallocSignal];
//    }
//}
//
//
//- (void)setShouldHideDetailButton:(BOOL)shouldHideDetailButton
//{
//    if (shouldHideDetailButton) {
//        self.detailButton.hidden = YES;
//        [self.downloadButton mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//        }];
//        [self layoutIfNeeded];
//    }
//}
//
//@end
