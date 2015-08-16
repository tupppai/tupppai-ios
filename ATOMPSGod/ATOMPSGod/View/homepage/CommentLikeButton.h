//
//  CommentLikeButton.h
//  ATOMPSGod
//
//  Created by atom on 15/4/30.
//  Copyright (c) 2015年 ATOM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentLikeButton : UIButton

@property (nonatomic, copy) NSString *likeNumber;
-(void)toggleNumber;
-(void)toggleLike;
-(void)toggleSelected;
-(void)toggleColor;
@end
