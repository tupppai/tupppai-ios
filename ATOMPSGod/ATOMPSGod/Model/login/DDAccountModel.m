//
//  ATOMSubmitUserInfomation.m
//  ATOMPSGod
//
//  Created by atom on 15/3/16.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import "DDAccountModel.h"
#import "DDSessionManager.h"
#import "ATOMUser.h"
#import "ATOMHomeImage.h"
#import "ATOMImageTipLabel.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self

@implementation DDAccountModel

+ (void )DDRegister:(NSDictionary *)param withBlock:(void (^)(BOOL success))block {
    [DDProfileService ddRegister:param withBlock:^(NSDictionary *data) {
        if (data) {
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:NULL];
            [[DDUserModel currentUser]saveAndUpdateUser:user];
            if (block) { block(YES); }
        } else {
            if (block) { block(NO); }
        }
    }];
}


+ (void )DDLogin:(NSDictionary*)param withBlock:(void (^)(BOOL succeed))block{
    [Hud activity:@""];
    [DDProfileService ddLogin:param withBlock:^(NSDictionary *data,NSInteger status) {
        [Hud dismiss];
        if (data) {
            {    //        data: { status: 1,正常  2，密码错误 3，未注册 }
                if(status == 1) {
                    [Util ShowTSMessageSuccess:@"登录成功"];
                    ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:nil];
                    //保存更新数据库的user,并更新currentUser
                    [[DDUserModel currentUser]saveAndUpdateUser:user];
                    if (block) {block(YES);}
                } else if (status == 2) {
                    [Util ShowTSMessageError:@"密码错误"];
                    if (block) { block(NO); }
                } else if (status == 3) {
                    [Util ShowTSMessageWarn:@"此手机号无注册"];
                    if (block) {block(NO);}
                }
            }
        } else { if (block) {  block(NO);  } }
    }];
}



+ (void)DD3PartyAuth:(NSDictionary *)param AndType:(NSString *)type withBlock:(void (^)(bool isRegistered,NSString* info))block {
    [Hud activity:@""];
    [DDProfileService dd3PartyAuth:param with3PaType:type withBlock:^(BOOL isRegistered,NSDictionary* userObejct) {
        if (isRegistered) {
            //已经注册，抓取服务器存储的user对象，更新本地user.
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:userObejct error:NULL];
            [[DDUserModel currentUser]saveAndUpdateUser:user];
            block(YES,@"登录成功");
        } else {
            if (block) {
                block(NO,@"未注册，跳到注册页面");
            }
        }
        
    }];
}

+ (void)ShowMyReply:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *returnArray))block {
    [DDProfileService getMyReply:param withBlock:^(NSArray *data) {
        if (data && data.count > 0 ) {
            NSMutableArray *returnArray = [NSMutableArray array];
            for (int i = 0; i < data.count; i++) {
                ATOMHomeImage *homeImage = [MTLJSONAdapter modelOfClass:[ATOMHomeImage class] fromJSONDictionary:[data objectAtIndex:i] error:NULL];
                homeImage.tipLabelArray = [NSMutableArray array];
                NSArray *labelDataArray = [[data objectAtIndex:i]objectForKey:@"labels"];
                if (labelDataArray.count > 0) {
                    for (int j = 0; j < labelDataArray.count; j++) {
                        ATOMImageTipLabel *tipLabel = [MTLJSONAdapter modelOfClass:[ATOMImageTipLabel class] fromJSONDictionary:[labelDataArray objectAtIndex:j] error:NULL];
                        tipLabel.imageID = homeImage.imageID;
                        [homeImage.tipLabelArray addObject:tipLabel];
                    }
                }
                [returnArray addObject:homeImage];
            }
            if (block) { block(returnArray); }
        }
        else {
            if (block) { block(nil); }
        }
    }];
}

+ (void)DDGetUserInfoAndUpdateMe {
    [DDProfileService ddGetMyInfo:nil withBlock:^(NSDictionary *data) {
        if (data) {
            ATOMUser* user = [MTLJSONAdapter modelOfClass:[ATOMUser class] fromJSONDictionary:data error:NULL];
            //保存更新数据库的user,并更新currentUser
            [[DDUserModel currentUser]saveAndUpdateUser:user];
        }
    }];
}


@end
