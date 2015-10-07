//
//  PIEFollowScrollView.h
//  ATOMPSGod
//
//  Created by chenpeiwei on 9/20/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

//typedef NS_ENUM(NSInteger, PIEFollowScrollType) {
//    PIEFollowScrollTypeFollow = 0,
//    PIEFollowScrollTypeHot
//};
@interface PIEEliteScrollView : UIScrollView
@property (nonatomic, strong) RefreshTableView *tableFollow;
@property (nonatomic, strong) RefreshTableView *tableHot;
@property (nonatomic, assign) PIEPageType type;
- (void)toggle ;
- (void)toggleWithType:(PIEPageType)type;
- (void)toggleType;
@end
