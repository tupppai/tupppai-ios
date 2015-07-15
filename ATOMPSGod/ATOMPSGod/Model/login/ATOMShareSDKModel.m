//
//  ATOMShareSDKModel.m
//  ATOMPSGod
//
//  Created by Peiwei Chen on 7/15/15.
//  Copyright (c) 2015 ATOM. All rights reserved.
//

#import "ATOMShareSDKModel.h"

@implementation ATOMShareSDKModel
//shareSDK 获取 用户手机的第三方平台的信息
+ (void)getUserInfo:(ShareType)type withBlock:(void (^)(NSDictionary* sourceData))block{
    [Util loadingHud:@""];
    NSLog(@"查看Iphone是否有登录的（微博，微信）客户端，并索取数据");
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        [Util dismissHud];
        NSLog(@"result %d, userInfo %@,error %@",result,userInfo,error);
        NSLog(@"user info%@ userUid %@ ,name %@,image %@",[userInfo description],[userInfo uid],[userInfo nickname],[userInfo profileImage]);
        if (result) {
            NSDictionary* sourceData = [userInfo sourceData];
            NSLog(@"sourceData %@",sourceData);
            block(sourceData);
        } else {
            block(nil);
        }
    }];
}
@end
