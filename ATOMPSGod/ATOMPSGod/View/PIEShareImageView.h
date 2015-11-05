//
//  PIEShareImageView.h
//  TUPAI
//
//  Created by chenpeiwei on 11/5/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIEShareImageView : UIView
@property (nonatomic,strong) UIImageView* avatarView;
@property (nonatomic,strong) UILabel* nameLabel;
@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) UIView* imageView_thumb_bg;
@property (nonatomic,strong) UIImageView* imageView_thumb;
@property (nonatomic,strong) UIImageView* imageView_type;

//@property (nonatomic,strong) UILabel* typeLabel;

@property (nonatomic,strong) UIImageView* imageView_thumb2;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) UILabel* label2;
@property (nonatomic,strong) UIImageView* QRCodeView;
@property (nonatomic,strong) UIImageView* imageView_appIcon;

-(void)injectSauce:(DDPageVM*)vm withBlock:(void(^)(BOOL success))block;
@end
