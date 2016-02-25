//
//  ATOMCreateTable.h
//  ATOMPSGod
//
//  Created by atom on 15/3/17.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATOMCreateTable : NSObject
+ (NSString *)createUser;

+ (NSString *)statamentForAddColumnForTable:(NSString*)tableStr column:(NSString*)columnStr dataType:(NSString*)dataType;



@end
