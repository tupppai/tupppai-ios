//
//  PIEFriendAskTableViewCell.h
//  TUPAI
//
//  Created by chenpeiwei on 10/4/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageVM.h"
@interface PIEFriendReplyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  UIImageView *theImageView;
- (void)injectSource:(DDPageVM*)vm;
@end
