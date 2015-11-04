//
//  PIESearchUserCollectionViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEUserViewModel.h"
#import "SwipeView.h"
@interface PIESearchUserCollectionViewCell : UICollectionViewCell<SwipeViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (weak, nonatomic) IBOutlet SwipeView *swipeView;

//@property (nonatomic, strong) NSArray* imageViewArray;
@property (nonatomic, strong) PIEUserViewModel* vm;

- (void)injectSauce:(PIEUserViewModel*)vm;
@end
