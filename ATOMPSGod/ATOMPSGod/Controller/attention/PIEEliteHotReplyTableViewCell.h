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


@interface PIEEliteHotReplyTableViewCell : UITableViewCell

@property (nonatomic,strong) PIEPageVM* vm;

//@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
//@property (weak, nonatomic) IBOutlet PIEAvatarImageView *avatarView;
@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//@property (weak, nonatomic) IBOutlet PIEPageButton *collectView;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *allWorkView;



@property (weak, nonatomic) IBOutlet PIEPageButton *shareView;

@property (weak, nonatomic) IBOutlet PIEPageButton *commentView;
@property (weak, nonatomic) IBOutlet PIELoveButton *likeView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *commentIndeicatorImageView;

@property (weak, nonatomic) IBOutlet UIImageView *followView;
@property (strong, nonatomic) PIEThumbAnimateView *thumbView;
- (void)injectSauce:(PIEPageVM *)viewModel;
- (void)animateToggleExpanded ;
- (void)animateThumbScale:(PIEAnimateViewType)type;
@end
