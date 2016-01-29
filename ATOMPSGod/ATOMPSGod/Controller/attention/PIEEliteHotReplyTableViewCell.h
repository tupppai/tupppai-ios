//
//  PIEEliteHotReplyTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/17/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEThumbAnimateView.h"
#import "PIEPageButton.h"
#import "PIELoveButton.h"
#import "PIEBangView.h"
#import "PIEAvatarImageView.h"
#import "PIEAvatarView.h"

#import "PIEBlurAnimateImageView.h"
#import "TTTAttributedLabel.h"

@class RACSignal;

@interface PIEEliteHotReplyTableViewCell : UITableViewCell

@property (nonatomic,strong) PIEPageVM* vm;

@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allWorkView;



@property (weak, nonatomic) IBOutlet PIEPageButton *shareView;

@property (weak, nonatomic) IBOutlet PIEPageButton *commentView;
@property (weak, nonatomic) IBOutlet PIELoveButton *likeView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *commentLabel1;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *commentLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *commentIndeicatorImageView;

@property (weak, nonatomic) IBOutlet PIEBlurAnimateImageView *blurAnimateView;

@property (weak, nonatomic) IBOutlet UIImageView *followView;


/*  RAC signals */
@property (nonatomic, strong) RACSignal *tapOnAvatarOrUsernameSignal;
@property (nonatomic, strong) RACSignal *tapOnFollowButtonSignal;
@property (nonatomic, strong) RACSignal *tapOnAllWorkSignal;
@property (nonatomic, strong) RACSignal *tapOnCommentSignal;
@property (nonatomic, strong) RACSignal *tapOnShareSignal;
@property (nonatomic, strong) RACSignal *tapOnLikeSignal;

- (void)injectSauce:(PIEPageVM *)viewModel;
- (void)animateWithType:(PIEThumbAnimateViewType)type;
@end
