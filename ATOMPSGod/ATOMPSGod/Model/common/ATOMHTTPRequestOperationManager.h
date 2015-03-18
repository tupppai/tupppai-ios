//
//  ATOMHTTPRequestOperationManager.h
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface ATOMHTTPRequestOperationManager : AFHTTPRequestOperationManager

+ (instancetype)sharedRequestOperationManager;

@end
