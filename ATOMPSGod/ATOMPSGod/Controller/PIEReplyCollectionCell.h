//
//  PIEReplyCollectionViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/2/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEPageLikeButton.h"

@interface PIEReplyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UIImageView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) PIEPageType type;
@property (weak, nonatomic) IBOutlet PIEPageLikeButton *likeButton;
@property (nonatomic, strong) DDPageVM *viewModel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (void)injectSauce:(DDPageVM *)viewModel;
@end
