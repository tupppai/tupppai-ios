//
//  ATOMCreateTable.m
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "ATOMCreateTable.h"

@implementation ATOMCreateTable

+ (NSString *)createUser {
    return @"create table ATOMUser (uid integer, mobile text, locationID integer, nickname text, avatar text, sex integer, backgroundImage text, attentionNumber integer, fansNumber integer, likeNumber integer, uploadNumber integer, replyNumber integer, proceedingNumber integer, attentionUploadNumber integer, attentionWorkNumber integer,bindWeibo bool,bindWechat bool,cityID integer,provinceID integer,isMyFan bool,isMyFollow bool)";
}

//+ (NSString *)createImageTipLabel {
//    return @"create table ATOMImageTipLabel (imageID integer, labelID integer, content text, x real, y real, labelDirection integer)";
//}

//+ (NSString *)createPIEImageEntity {
//    return @"create table PIEImageEntity (height integer, width integer, url text)";
//}
+ (NSString *)createPIEImageEntity{
    return @"create table PIEImageEntity (ID integer, width integer, height integer, url text)";
}

+ (NSString *)createHomeImage {
    return @"create table PIEPageEntity (ID integer ,askID integer ,uid integer, nickname integer, avatar text, uploadTime bigint, imageURL text, userDescription text, isDownload integer, totalPraiseNumber integer, totalCommentNumber integer, totalShareNumber integer, totalWXShareNumber integer, totalWorkNumber integer, imageWidth real, imageHeight real,homePageType text,liked bool,collected bool,type integer,thumbEntityArray null)";
}

+ (NSString *)createComment {
    return @"create table ATOMComment (cid integer, imageID integer, detailID integer, commentType integer, uid integer, nickname text, avatar text, content text, commentTime bigint, likeNumber integer, atCommentArray null,liked bool)";
}

//+ (NSString *)createDetailImage {
//    return @"create table ATOMDetailImage (detailID integer,askID integer, imageID integer, uid integer, nickname text, avatar text, replyTime bigint, imageURL text, replyDescription text, isDownload integer, totalPraiseNumber integer, totalCommentNumber integer, totalShareNumber integer, totalWXShareNumber integer, totalWorkNumber integer, imageWidth real, imageHeight real, hotCommentArray null, clickTime bigint, liked bool,collected bool,type integer)";
//}

@end
