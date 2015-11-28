//
//  PIEImageView_blur.m
//  TUPAI
//
//  Created by chenpeiwei on 11/28/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIEImageView_blur.h"
#import "FXBlurView.h"
@implementation PIEImageView_blur

-(void)setImage:(UIImage *)image {
    [super setImage:[image blurredImageWithRadius:100 iterations:1 tintColor:[UIColor blackColor]]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
