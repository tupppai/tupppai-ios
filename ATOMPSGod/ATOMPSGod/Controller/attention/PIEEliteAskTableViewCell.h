//
//  PIEEliteAskTableViewCell.h
//  TUPAI
//
//  Created by TUPAI-Huangwei on 2/20/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIEPageVM;
@interface PIEEliteAskTableViewCell : UITableViewCell

- (void)bindVM:(PIEPageVM *)pageVM;

/* Signals */
@property (nonatomic, strong) RACSignal *tapOnUserSignal;

@property (nonatomic, strong) RACSignal *tapOnFollowButtonSignal;

@property (nonatomic, strong) RACSignal *tapOnImageSignal;

@property (nonatomic, strong) RACSignal *longPressOnImageSignal;

@property (nonatomic, strong) RACSignal *tapOnCommentSignal;

@property (nonatomic, strong) RACSignal *tapOnShareSignal;

@property (nonatomic, strong) RACSignal *tapOnBangSignal;

@property (nonatomic, strong) RACSignal *tapOnRelatedWorkSignal;


@end
