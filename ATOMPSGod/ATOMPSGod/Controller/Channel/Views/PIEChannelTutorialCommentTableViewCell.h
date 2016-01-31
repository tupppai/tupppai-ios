//
//  PIEChannelTutorialCommentTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/27/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEAvatarView;
@class PIECommentVM;

@interface PIEChannelTutorialCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;


- (void)injectVM:(PIECommentVM *)commentVM;

@end
