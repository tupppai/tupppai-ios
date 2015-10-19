//
//  PIEFollowScrollView.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIERefreshTableView.h"

@interface PIEEliteScrollView : UIScrollView
@property (nonatomic, strong) PIERefreshTableView *tableFollow;
@property (nonatomic, strong) PIERefreshTableView *tableHot;
@property (nonatomic, assign) PIEPageType type;
- (void)toggle ;
- (void)toggleWithType:(PIEPageType)type;
- (void)toggleType;
@end
