//
//  PWBaseTableView.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATOMNoDataView.h"
@protocol PWBaseTableViewDelegate <NSObject>
/**
 * 向下拉tableView触发
**/
-(void) didPullRefreshDown:(UITableView*)tableView;
/**
 * 拉到tableView底部时，继续向上拉触发
 **/-(void) didPullRefreshUp:(UITableView*)tableView;
@end
@interface PWBaseTableView : UITableView
@property (nonatomic, weak) id<PWBaseTableViewDelegate> psDelegate;
@property (nonatomic, strong) ATOMNoDataView *noDataView;
-(void)reloadDataCustom;
@end
