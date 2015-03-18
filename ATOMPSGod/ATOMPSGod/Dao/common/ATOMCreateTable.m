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
    return @"create table ATOMUser (uid text, mobile text, locationID integer, nickname text, avatar text, sex integer, backgroundImage text, attentionNumber integer, fansNumber integer, praiseNumber integer, uploadNumber integer, replyNumber integer, proceedingNumber integer, attentionUploadNumber integer, attentionWorkNumber integer)";
}

@end
