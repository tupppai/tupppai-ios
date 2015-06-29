//
//  ATOMDetailImage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/20.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"

@interface ATOMDetailImage : ATOMBaseModel <MTLFMDBSerializing>

/**
 *  原作品ID
 */
@property (nonatomic, assign) NSInteger imageID;
/**
 *  是否被赞过
 */
@property (nonatomic, assign) BOOL liked;
/**
 *  回复ID
 */
@property (nonatomic, assign) NSInteger detailID;
/**
 *  回复人ID
 */
@property (nonatomic, assign) NSInteger uid;
/**
 *  回复人头像
 */
@property (nonatomic, copy) NSString *avatar;
/**
 *  回复人性别
 */
@property (nonatomic, assign) NSInteger sex;
/**
 *  回复人昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  回复时间
 */
@property (nonatomic, assign) long long replyTime;
/**
 *  回复描述
 */
@property (nonatomic, copy) NSString *replyDescription;
/**
 *  作品URL
 */
@property (nonatomic, copy) NSString *imageURL;
/**
 *  作品宽度
 */
@property (nonatomic, assign) CGFloat imageWidth;
/**
 *  作品高度
 */
@property (nonatomic, assign) CGFloat imageHeight;
/**
 *  是否被下载
 */
@property (nonatomic, assign) NSInteger isDownload;
/**
 *  点赞数
 */
@property (nonatomic, assign) NSInteger totalPraiseNumber;
/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger totalCommentNumber;
/**
 *  分享数
 */
@property (nonatomic, assign) NSInteger totalShareNumber;
/**
 *  微信分享数
 */
@property (nonatomic, assign) NSInteger totalWXShareNumber;
/**
 *  首页图片点击时间（用于统计）
 */
@property (nonatomic, assign) long long clickTime;
/**
 *  热门评论数组
 */
@property (nonatomic, strong) NSMutableArray *hotCommentArray;






































@end
