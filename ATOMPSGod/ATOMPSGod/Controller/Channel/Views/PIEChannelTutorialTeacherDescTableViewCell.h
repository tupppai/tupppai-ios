//
//  PIEChannelTutorialTeacherDescTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/25/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEAvatarView;
@class PIEChannelTutorialModel;
@interface PIEChannelTutorialTeacherDescTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel       *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel       *createdTimeLabel;

- (void)injectModel:(PIEChannelTutorialModel *)tutorialModel;

@end
