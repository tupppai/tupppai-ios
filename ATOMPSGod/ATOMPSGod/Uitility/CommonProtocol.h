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
-(void) didPullDownCollectionView:(UICollectionView*)collectionView;
/**
 * 拉到底部时，继续向上拉触发
 **/-(void) didPullUpCollectionViewBottom:(UICollectionView*)collectionView;
@end

@protocol ATOMViewControllerDelegate <NSObject>
@optional
- (void)ATOMViewControllerDismissWithLiked:(BOOL)liked;
- (void)ATOMViewControllerDismissWithInfo:(NSDictionary*)info;

@end

@protocol PIEShareFunctionViewDelegate <NSObject>
@optional
- (void)tapWechatFriends;
- (void)tapWechatMoment;
- (void)tapSinaWeibo;
- (void)tapInvite;
- (void)tapCollect;
- (void)tapReport;
@end


@protocol PIEShareViewDelegate <NSObject>
@optional
- (void)tapShare1;
- (void)tapShare2;
- (void)tapShare3;
- (void)tapShare4;
- (void)tapShare5;
- (void)tapShare6;
- (void)tapShare7;
- (void)tapShare8;
- (void)tapShareCancel;
@end

