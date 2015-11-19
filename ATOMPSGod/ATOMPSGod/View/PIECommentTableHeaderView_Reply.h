//
//  PIECommentTableHeaderView_Reply.h
//  TUPAI
//
//  Created by chenpeiwei on 11/10/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEPageButton.h"
#import "PIEPageLikeButton.h"
@interface PIECommentTableHeaderView_Reply : UIView
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageViewMain;
@property (nonatomic, strong) UIImageView *imageViewRight;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *moreWorkButton;
@property (nonatomic, strong) PIEPageButton *commentButton;
@property (nonatomic, strong) PIEPageButton *shareButton;
@property (nonatomic, strong) PIEPageLikeButton *likeButton;
@property (nonatomic, strong) PIEPageVM *vm;
@end
