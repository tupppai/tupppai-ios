//
//  ATOMHomeImage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"
@class ATOMUser;

@interface PIEPageEntity : ATOMBaseModel <MTLFMDBSerializing>

/**
 *  自己的ID
 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) bool liked;
@property (nonatomic, assign) bool collected;
/**
 *  类型：hot ,recent
 */
@property (nonatomic, copy) NSString *homePageType;
/**
 *  求P，作品：ATOMPageTypeAsk ,ATOMPageTypeReply
 */
@property (nonatomic, assign) NSInteger type;
/**
 *  求P人 ID
 */
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
/**
 *  作品上传时间
 */
@property (nonatomic, assign) long long uploadTime;
/**
 *  作品URL
 */
@property (nonatomic, copy) NSString *imageURL;
/**
 *  求P要求
 */
@property (nonatomic, copy) NSString *userDescription;
/**
 *  是否被下载
 */
@property (nonatomic, assign) NSInteger isDownload;
/**
 *  总赞数
 */
@property (nonatomic, assign) NSInteger totalPraiseNumber;
/**
 *  总评论数
 */
@property (nonatomic, assign) NSInteger totalCommentNumber;
/**
 *  总分享数
 */
@property (nonatomic, assign) NSInteger totalShareNumber;
/**
 *  总微信分享数
 */
@property (nonatomic, assign) NSInteger totalWXShareNumber;
/**
 *  总被P数
 */
@property (nonatomic, assign) NSInteger totalWorkNumber;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;


@property (nonatomic, copy) NSArray *askImageModelArray;

/**
 *  作品的标签数组
 */
//@property (nonatomic, strong) NSMutableArray *tipLabelArray;
/**
 *  回复人数组
 */
//@property (nonatomic, strong) NSMutableArray *replierArray;

















@end
