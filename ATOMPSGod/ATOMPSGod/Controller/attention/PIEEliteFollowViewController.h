//
//  PIEEliteFollowReplyViewController.h
//  TUPAI
//
//  Created by huangwei on 15/12/17.
//  Copyright © 2015年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "DDBaseVC.h"
#import "LeesinViewController.h"

@interface PIEEliteFollowViewController : DDBaseVC
<
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate,
    LeesinViewControllerDelegate
>

- (void)getSourceIfEmpty_follow:(void (^)(BOOL finished))block;

- (void)refreshMoments;


@end
