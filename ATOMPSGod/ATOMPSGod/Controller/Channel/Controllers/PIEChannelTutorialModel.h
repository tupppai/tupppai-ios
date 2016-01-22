//
//  PIEChannelTutorialModel.h
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBaseModel.h"

@interface PIEChannelTutorialModel : PIEBaseModel

/** 教程ID */
@property (nonatomic, assign) NSInteger ID;

/** 因为教程本质上是一个求P（ask），所以传了一个ask_id 回来。这个字段与ID值是一样的 */
@property (nonatomic, assign) NSInteger ask_id;

/** 该教程的发布时间 */
@property (nonatomic, copy  ) NSString  *publishTime;

/** 该教程的标题 */
@property (nonatomic, copy  ) NSString  *title;

/** 该教程的副描述（左边有一个竖线，在markdown里用 > 表示的那种） */
@property (nonatomic, copy  ) NSString  *subTitle;

/** 其他用户对这个教程的总点赞数 */
@property (nonatomic, assign) NSInteger love_count;

/** 教程的点击数 */
@property (nonatomic, assign) NSInteger click_count;

/** 其他用户上缴的作业的总数（有多少人完成了PS教程的作业并上传） */
@property (nonatomic, assign) NSInteger reply_count;

/** 该教程的图片。未分享到朋友圈，或者没给钱（打赏），则只返回两张图片 */
@property (nonatomic, strong) NSArray   *tutorial_images;

/** 之前用户是否有分享到微信页面，0： false， 1： true */
@property (nonatomic, assign) BOOL      hasSharedToWechat;

/** 当前用户对这个教程已经打赏了多少钱， -1： 从来都没有打赏过
    Warning： 永远都不要对浮点数判断等值（== -1），
             直接用（payment < 0）来判断用户是否有打赏过金额。*/
@property (nonatomic, assign) double    paidAmount;


@end
