//
//  PIEChannelTutorialListCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/24/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEAvatarView;
@class PIEChannelTutorialModel;

@interface PIEChannelTutorialListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView   *tutorialImageView;
@property (weak, nonatomic) IBOutlet UILabel       *tutorialTitle;
@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel       *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel       *loveCountLabel;
@property (weak, nonatomic) IBOutlet UILabel       *clickCountLabel;
@property (weak, nonatomic) IBOutlet UILabel       *replyCountLabel;


- (void)injectModel:(PIEChannelTutorialModel *)tutorialModel;


@end
