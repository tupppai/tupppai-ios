//
//  YZSDK.h
//  CustomerNetwork
//
//  Created by 益达 on 15/11/19.
//  Copyright (c) 2015年 张伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YZUserModel.h"

@interface YZSDK : NSObject

+ (instancetype) sharedInstance;

/**
 *  设置UA
 *
 *  @param userAgent 这里注意UA的格式，kdtUnion_xxxx
 *  @param version   app的版本号【可选,可以设置为空】
 */
+ (void) userAgentInit:(NSString *)userAgent version:(NSString *) version;

/**
 *  获取userAgent
 *
 *  @return 
 */
+ (NSString *) getUserAgent;

/**
 *  获取userAgent带有浏览器信息
 *
 *  @return 
 */
+ (NSString *) getUserAgentContent;

/**
 *  根据制定模块的协议获取Service
 *
 *  @param protocol
 *
 *  @return
 */
- (id) getService:(Protocol *)protocol;

/**
 *  是否开启日志【必须在debug模式下才有效，release模式下无效】
 *
 *  @param open YES是开启，NO是关闭
 */
+ (void) setOpenDebugLog:(BOOL) open;

/**
 *  设置appID
 *
 *  @param appID
 */
+ (void) setOpenInterfaceAppID:(NSString *) appID;

/**
 *  市值appSecret
 *
 *  @param appSecret
 */
+ (void) setOpenInterfaceAppSecret:(NSString *) appSecret;

/**
 *  设置appID和appSecret
 *
 *  @param appID
 *  @param appSecret
 */
+ (void) setOpenInterfaceAppID:(NSString *) appID appSecret:(NSString *) appSecret;


/**
 *  获取sdk的版本号
 *
 *  @return sdk的版本号
 */
+ (NSString *) getSdkVersion;

/**
 *  提供给微信自有支付，【考虑到获取微信】
 *
 *  @param IPAddress ip地址
 */
+ (void) setSelfWxPayInterfaceClientIPAddress:(NSString *)IPAddress;

/**
 *  同步三方app用户信息到有赞服务端【没有带有回调函数】
 *
 *  @param userModel
 */
+ (void) registerYZUser:(YZUserModel *)userModel;

/**
 *   同步三方app用户信息到有赞服务端【带有回调函数，判断用户信息同步成功或者失败】
 *
 *  @param userModel
 *  @param callback
 */
+ (void) registerYZUser:(YZUserModel *)userModel callBack:(void (^)(NSString *message , BOOL isError) ) callback;

/**
 * 微信自有支付信息【使用这个接口式，请注意记得设置app的ip地址】
 *
 *  @param url      回调链接
 *  @param callback  回调block
 */
+ (void) selfWXPayURL:(NSURL *) url callback:(void (^)(NSDictionary * response , NSError *error)) callback;

/**
 *  退出登录
 *
 *  @param viewContrller 基于vc
 *
 *  @return YES，退出成功  NO退出失败
 */
+ (BOOL) logoutYouzanViewController:(UIViewController *)viewContrller;

/**
 *  退出登录
 *
 *  @param pageView 基于view
 *
 *  @return YES退出成功  NO退出失败
 */
+ (BOOL) logoutYouzanPageView:(UIView *)pageView;

/**
 *  是否显示页面顶部黑条，默认是显示
 *
 *  @param show YES,显示; NO,隐藏.
 */
+ (void)showTopShopBar:(BOOL)show;


/*
 **************************之前的web交互模式  兼容之前1.0的开发模式
 */
/**
 *  页面加载完成，对js进行初始化
 *
 */
- (NSString *) jsBridgeWhenWebDidLoad;

/**
 * 点击分享按钮，触发web分享数据回调
 */
- (NSString *) jsBridgeWhenShareBtnClick;

/**
 *  解析url的参数
 *
 *  @param url 当前传入的url参数
 *
 *  @return 
 *  1. CHECK_LOGIN 验证是否登录  没有登录，跳转到登录页面；如果已经登录，直接调用webUserInfoLogin方法写入用户信息
 *  2. SHARE_DATA 数据分享
 *  3. WEB_READY 页面资源是否加载完毕
 *  4. WX_PAY 微信支付
 */
- (NSString *) parseYOUZANScheme:(NSURL *) url;

/**
 *  将客户端获取的用户信息同步到web端
 *
 *  @param userInfo 用户信息，包含用户唯一识别的id，性别，昵称等等，详情见文档说明
 *
 *  @return
 */
- (NSString *) webUserInfoLogin:(YZUserModel *)userInfo;

/**
 *  获取分享数据
 *
 *  @param url 分享的URL中可以解析需要分享的数据
 *
 *  @return
 */
- (NSDictionary *) shareDataInfo:(NSURL *) url;

@end
