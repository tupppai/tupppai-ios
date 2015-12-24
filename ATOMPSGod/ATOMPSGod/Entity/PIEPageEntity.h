//
//  ATOMHomeImage.h
//  ATOMPSGod
//
//  Created by atom on 15/3/18.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMBaseModel.h"
@class PIECommentEntity;
@class PIEImageEntity;
@interface PIEPageEntity : ATOMBaseModel <MTLFMDBSerializing>

/**
 *  自己的ID
 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger askID;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL collected;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) BOOL isMyFan;

/**
 *  求P，作品：PIEPageTypeAsk ,PIEPageTypeReply
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

@property (nonatomic, assign) NSInteger collectCount;

@property (nonatomic, assign) NSInteger totalWorkNumber;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat imageRatio;


@property (nonatomic, copy) NSArray <PIEImageEntity*>*thumbEntityArray;
@property (nonatomic, copy) NSArray <PIECommentEntity*>*models_comment;



@end
