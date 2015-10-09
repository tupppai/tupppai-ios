//
//  PIECollectionViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/7/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEMyPhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
- (void)injectSauce:(DDPageVM*)vm;
@end
