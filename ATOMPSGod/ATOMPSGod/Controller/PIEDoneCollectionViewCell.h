//
//  PIEDoneCollectionViewCell.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEDoneCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *blurBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
- (void)injectSauce:(DDPageVM*)vm ;
@end
