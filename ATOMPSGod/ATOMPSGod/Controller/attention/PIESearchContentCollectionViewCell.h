//
//  PIESearchContentCollectionViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 11/3/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIESearchContentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (void)injectSauce:(DDPageVM*)vm ;
@end
