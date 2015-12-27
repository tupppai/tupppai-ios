//
//  PIECommentTableHeaderView_Reply.h
//  TUPAI
//
//  Created by chenpeiwei on 11/10/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEPageButton.h"
#import "PIELoveButton.h"
#import "PIETextView_linkDetection.h"
#import "PIEAvatarImageView.h"
@interface PIECommentTableHeaderView_Reply : UIView

@property (nonatomic, strong) PIEAvatarImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIImageView *imageViewMain;
//@property (nonatomic, strong) UIImageView *imageViewRight;
@property (nonatomic, strong) UIImageView *imageViewBlur;
@property (nonatomic, strong) PIETextView_linkDetection *textView_content;
@property (nonatomic, strong) UIButton *moreWorkButton;
@property (nonatomic, strong) PIEPageButton *commentButton;
@property (nonatomic, strong) PIEPageButton *shareButton;
@property (nonatomic, strong) PIELoveButton *likeButton;
@property (nonatomic, strong) PIEPageVM *vm;
@end
