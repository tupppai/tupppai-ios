//
//  PIECarousel_ItemView_new.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/23/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIEAvatarView;
@class PIEBlurAnimateImageView;
@class PIELoveButton;

@interface PIECarousel_ItemView_new : UIView

@property (weak, nonatomic) IBOutlet PIEAvatarView           *avatarView;

@property (weak, nonatomic) IBOutlet UILabel                 *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel                 *createdTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView             *askIconImageView;

@property (weak, nonatomic) IBOutlet UIImageView             *replyIconImageView;

@property (weak, nonatomic) IBOutlet PIEBlurAnimateImageView *blurAnimateImageView;

@property (weak, nonatomic) IBOutlet UIButton                *downloadButton;

@property (weak, nonatomic) IBOutlet UIButton                *detailButton;

@property (weak, nonatomic) IBOutlet PIELoveButton           *loveButton;

//@property (weak, nonatomic) IBOutlet UIImageView             *bangIconImageView;


+ (PIECarousel_ItemView_new *)itemView;

- (void)injectPageVM:(PIEPageVM *)pageVM;

- (void)setShouldHideDetailButton:(BOOL)shouldHideDetailButton;

@end
