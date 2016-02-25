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
    return @"create table PIEUserTable (uid integer, mobile text, locationID integer, nickname text, avatar text, sex integer, backgroundImage text, attentionNumber integer, fansNumber integer, uploadNumber integer, replyNumber integer, proceedingNumber integer, attentionUploadNumber integer, attentionWorkNumber integer,bindWeibo bool,bindWechat bool,cityID integer,provinceID integer,isMyFan bool,isMyFollow bool,token text,likedCount integer,bindQQ bool,blocked bool,isV bool,balance real)";
}

+ (NSString *)statamentForAddColumnForTable:(NSString*)tableStr column:(NSString*)columnStr dataType:(NSString*)dataType{
    NSString *str = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@;",tableStr,columnStr,dataType];
    return str;
}

@end
