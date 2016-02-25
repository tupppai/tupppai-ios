//
//  PIEBlurAnimateImageView.h
//  TUPAI
//
//  Created by chenpeiwei on 1/18/16.
//  Copyright © 2016 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIEThumbAnimateView.h"

@interface PIEBlurAnimateImageView : UIView

@property (nonatomic,strong)PIEPageVM *viewModel;

@property (nonatomic,strong)UIImageView *blurBackgroundImageView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)PIEThumbAnimateView *thumbView;
@property (nonatomic,assign)BOOL enlarged;

- (void)animateWithType:(PIEThumbAnimateViewType)type;
- (void)prepareForReuse;
//- (void)animate;
@end
