//
//  ATOMPageCommentViewController.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 8/13/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMBaseViewController.h"
#import "kfcPageVM.h"

@interface ATOMPageCommentViewController : ATOMBaseViewController
@property (nonatomic, strong) kfcPageVM *pageDetailViewModel;

//回传 是否点赞 到 parent VC
@property (nonatomic, weak)   id<ATOMViewControllerDelegate> delegate;

@end