//
//  CommonProtocol.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/19/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//
@class PWRefreshFooterCollectionView;
#ifndef ATOMPSGod_CommonProtocol_h
#define ATOMPSGod_CommonProtocol_h
#endif
@protocol PWRefreshBaseTableViewDelegate <NSObject>
@optional
/**
 * 向下拉tableView触发
 **/
-(void) didPullRefreshDown:(UITableView*)tableView;
/**
 * 拉到tableView底部时，继续向上拉触发
 **/-(void) didPullRefreshUp:(UITableView*)tableView;
@end

@protocol PWRefreshBaseCollectionViewDelegate <NSObject>
@optional
/**
 * 向下拉触发
 **/
-(void) didPullDownCollectionView:(PWRefreshFooterCollectionView*)collectionView;
/**
 * 拉到底部时，继续向上拉触发
 **/-(void) didPullUpCollectionViewBottom:(PWRefreshFooterCollectionView*)collectionView;
@end

@protocol ATOMViewControllerDelegate <NSObject>
@optional
- (void)ATOMViewControllerDismissWithLiked:(BOOL)liked;
- (void)ATOMViewControllerDismissWithInfo:(NSDictionary*)info;

@end

@protocol ATOMShareFunctionViewDelegate <NSObject>
@optional
- (void)tapWechatFriends;
- (void)tapWechatMoment;
- (void)tapSinaWeibo;
- (void)tapInvite;
- (void)tapCollect;
- (void)tapReport;
@end
