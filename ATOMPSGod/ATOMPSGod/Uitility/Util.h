//
//  Util.h
//  ATOMPSGod
//
//  Created by Peiwei Chen on 6/18/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
+(void)TextHud:(NSString*)message;
+(void)TextHud:(NSString*)message inView:(UIView*)view;
+(void)loadingHud:(NSString*)message;
+(void)loadingHud:(NSString*)message inView:(UIView*)view;
+(void)dismissHud;
+(void)dismissHud:(UIView*)view;
+(void)successHud:(NSString*)message inView:(UIView*)view;
+(void)showSuccess:(NSString*)message;
@end
