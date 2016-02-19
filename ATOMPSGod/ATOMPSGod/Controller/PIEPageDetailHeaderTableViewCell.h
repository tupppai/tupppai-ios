//
//  PIEPageDetailHeaderTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 2/19/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEAvatarButton;
@class PIEBlurAnimateImageView;
@class PIEPageButton;
@class PIEPageCollectionSwipeView;

@interface PIEPageDetailHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PIEAvatarButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *usernameButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet PIEBlurAnimateImageView *blurAnimateImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pageCollectionViewHeightContraint;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet PIEPageButton *shareButtonView;
@property (weak, nonatomic) IBOutlet PIEPageCollectionSwipeView *pageCollectionSwipeView;

@property (nonatomic,strong) PIEPageVM *viewModel;
@end
