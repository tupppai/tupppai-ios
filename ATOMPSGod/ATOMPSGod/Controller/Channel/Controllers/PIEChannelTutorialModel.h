//
//  PIEChannelTutorialModel.h
//  TUPAI
//
//  Created by huangwei on 16/1/22.
//  Copyright © 2016年 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEBaseModel.h"
#import "PIEChannelTutorialImageModel.h"

@interface PIEChannelTutorialModel : PIEBaseModel

/** 教程ID */
@property (nonatomic, assign) NSInteger ID;

/** 因为教程本质上是一个求P（ask），所以传了一个ask_id 回来。这个字段与ID值是一样的 */
@property (nonatomic, assign) NSInteger ask_id;

/** 用户名 */
@property (nonatomic, strong) NSString  *userName;

/** 该用户是否是我的粉丝 */
@property (nonatomic, assign) BOOL isMyFan;

/** 该用户是否是我的关注 */
@property (nonatomic, assign) BOOL isMyFollow;

/** 用户头像URL */
@property (nonatomic, strong) NSString  *avatarUrl;

/** 该教程的发布时间 */
@property (nonatomic, copy  ) NSString  *publishTime;

/** 该教程的标题 */
@property (nonatomic, copy  ) NSString  *title;

/** 该教程的副描述（左边有一个竖线，类似markdown里用 > 表示的那种） */
@property (nonatomic, copy  ) NSString  *subTitle;

/** 其他用户对这个教程的总点赞数 */
@property (nonatomic, assign) NSInteger love_count;

/** 教程的点击数 */
@property (nonatomic, assign) NSInteger click_count;

/** 其他用户上缴的作业的总数（有多少人完成了PS教程的作业并上传） */
@property (nonatomic, assign) NSInteger reply_count;

/** 其它用户对这个教程的总评论 */
@property (nonatomic, assign) NSInteger comment_count;

/** 该教程的图片。未分享到朋友圈，或者没给钱（打赏），则只返回两张图片 */
@property (nonatomic, strong) NSArray<PIEChannelTutorialImageModel *>   *tutorial_images;

/** 该教程的封面（目前是tutorial_images的第一张图片，但是服务器返回的时候顺便放到了最外层了 */
@property (nonatomic, strong) NSString  *coverImageUrl;

/** 判断是否购买过该教程的用has_bought, 0是未购买（或分享到朋友圈， 下同），1是已购买  */
@property (nonatomic, assign) BOOL hasBought;


@end
