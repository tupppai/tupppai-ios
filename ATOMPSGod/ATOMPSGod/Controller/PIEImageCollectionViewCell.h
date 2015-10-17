//
//  PIEMyAskCollectionViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/12/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pageImgaeView;
- (void)injectSauce:(DDPageVM*)vm;
@end
