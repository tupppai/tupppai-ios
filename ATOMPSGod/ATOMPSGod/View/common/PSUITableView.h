//
//  PSUITableView.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/4/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSUITableViewDelegate <NSObject>
/**
 * 向下拉tableView触发
**/
-(void) didPullRefreshDown:(UITableView*)tableView;
/**
 * 拉到tableView底部时，继续向上拉触发
 **/-(void) didPullRefreshUp:(UITableView*)tableView;
@end

@interface PSUITableView : UITableView
@property (nonatomic, weak) id<PSUITableViewDelegate> psDelegate;
@end
