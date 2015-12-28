//
//  PIEAskCollectionCell.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/16/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEAvatarImageView.h"
#import "PIEAvatarView.h"

@interface PIENewAskCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PIEAvatarView *avatarView;
@property (nonatomic,strong) PIEPageVM* vm;
//@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
//@property (weak, nonatomic) IBOutlet PIEAvatarImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bangView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_multiAskSign;
- (void)injectSource:(PIEPageVM*)vm;
@end
