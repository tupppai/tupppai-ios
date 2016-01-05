//
//  MacroUtils.h
//  ATOMPSGod
//
//  Created by atom on 15/3/2.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#ifndef ATOMPSGod_MacroUtils_h
#define ATOMPSGod_MacroUtils_h


#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SCALE [[UIScreen mainScreen] scale]
#define SCREEN_WIDTH_RESOLUTION (SCREEN_SCALE * SCREEN_WIDTH)
#define NAV_HEIGHT 64
#define TAB_HEIGHT 49
#define CGWidth(rect)                   rect.size.width
#define CGHeight(rect)                  rect.size.height
#define CGOriginX(rect)                 rect.origin.x
#define CGOriginY(rect)                 rect.origin.y

//#define baseURLString @"http://api.qiupsdashen.com/"

/*
    To peiwei: 
    没办法我又不知道怎么在新的launchViewController里做出“点击14下切换服务器”的这个功能，然后强哥那边的baseURL因为没有向腾讯备案要改，所以只能出此下策咯。
 */
#define baseURLString @"http://api2.loiter.us/"
#define baseURLString_Test @"http://api2.loiter.us/"

#define _S(number) (number*[ATOMBaseView scaleInView])
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self
#endif
