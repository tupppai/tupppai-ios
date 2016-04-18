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


#define baseURLString @"http://api.qiupsdashen.com/"
#define baseURLString_Test @"http://tapi.tupppai.com/"

#define _S(number) (number*[ATOMBaseView scaleInView])
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif


#endif
