//
//  PIEDoneCollectionViewCell.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/18/15.
//  Copyright (c) 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageVM.h"
@interface PIEDoneCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
- (void)injectSauce:(DDPageVM*)vm;
@end
