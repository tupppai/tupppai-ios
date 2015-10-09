//
//  PIEReplyCollectionViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/2/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEReplyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) PIEPageType type;

- (void)injectSauce:(DDPageVM *)viewModel;
@end
