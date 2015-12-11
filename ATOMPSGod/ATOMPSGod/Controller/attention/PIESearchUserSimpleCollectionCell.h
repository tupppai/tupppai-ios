//
//  PIESearchUserTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 11/24/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEUserViewModel.h"
#import "SwipeView.h"
@interface PIESearchUserSimpleCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@property (nonatomic, strong) PIEUserViewModel* vm;

- (void)injectSauce:(PIEUserViewModel*)vm;


@end
