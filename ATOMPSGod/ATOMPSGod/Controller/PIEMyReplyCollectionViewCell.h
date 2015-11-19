//
//  PIECollectionViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/7/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEMyReplyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *blurBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
- (void)injectSauce:(PIEPageVM*)vm;
@end
