//
//  PIEPageCommentTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 2/23/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIECommentVM.h"

@interface PIEPageCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UILabel *receiveNameLabel;


-(void)getSource:(PIECommentVM *)vm;
@end
