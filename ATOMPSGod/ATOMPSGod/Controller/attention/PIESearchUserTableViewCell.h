//
//  PIESearchUserTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 1/17/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PIEUserViewModel;
@class PIEAvatarButton;
@class SwipeView;

@interface PIESearchUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PIEAvatarButton *avatarButton;

@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

@property (nonatomic, strong) PIEUserViewModel* vm;

- (void)injectSauce:(PIEUserViewModel*)vm;
@end
