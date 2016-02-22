//
//  PIEEliteReplyTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/20/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIEPageVM;
@interface PIEEliteReplyTableViewCell : UITableViewCell


- (void)bindVM:(PIEPageVM *)pageVM;

/* Signals */
@property (nonatomic, strong) RACSignal *tapOnUserSignal;

@property (nonatomic, strong) RACSignal *tapOnFollowButtonSignal;

@property (nonatomic, strong) RACSignal *tapOnImageSignal;

@property (nonatomic, strong) RACSignal *longPressOnImageSignal;

@property (nonatomic, strong) RACSignal *tapOnCommentSignal;

@property (nonatomic, strong) RACSignal *tapOnShareSignal;

@property (nonatomic, strong) RACSignal *tapOnLoveSignal;

@property (nonatomic, strong) RACSignal *longPressOnLoveSignal;

@property (nonatomic, strong) RACSignal *tapOnRelatedWorkSignal;

@end
