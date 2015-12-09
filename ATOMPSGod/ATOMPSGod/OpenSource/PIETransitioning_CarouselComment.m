//
//  PIETransitioning_Carousel.m
//  TUPAI
//
//  Created by chenpeiwei on 12/8/15.
//  Copyright © 2015 Shenzhen Pires Internet Technology CO.,LTD. All rights reserved.
//

#import "PIETransitioning_CarouselComment.h"


@implementation PIETransitioning_CarouselComment

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    CGFloat scale_h = (414-40)/414.0;
    CGFloat scale_v = (736-94)/736.0;
    
    CGFloat width  = SCREEN_WIDTH *scale_h;
    CGFloat height = SCREEN_HEIGHT*scale_v;
    CGFloat margin_v = (SCREEN_HEIGHT - height);
    UIView * wView = [UIView new];
    
    
    if (self.isPresentation) {
        wView.frame = CGRectMake((SCREEN_WIDTH-width)/2, SCREEN_HEIGHT, width, containerView.frame.size.height);
    } else {
        wView.frame = CGRectMake((SCREEN_WIDTH-width)/2, margin_v, width, containerView.frame.size.height);
    }
    wView.layer.cornerRadius = 10;
    wView.clipsToBounds = YES;
    
    wView.backgroundColor = [UIColor whiteColor];
    if (self.isPresentation) {
        [containerView addSubview:toView];
        [containerView addSubview:wView];
    } else {
        //        [containerView addSubview:fromView];
        //        [containerView addSubview:wView];
    }
    
    
    UIViewController *animatingViewController = self.isPresentation ? toViewController : fromViewController;
    UIView *animatingView = self.isPresentation ? toView : fromView;
    
    animatingView.alpha = self.isPresentation? 0.0:0.8;
    
    CGRect onScreenFrame = [transitionContext finalFrameForViewController:animatingViewController];
    CGRect offScreenFrame = CGRectOffset(onScreenFrame, 0, onScreenFrame.size.height);
    
    CGRect initialFrame = self.isPresentation ? offScreenFrame : onScreenFrame;
    CGRect finalFrame = self.isPresentation ? onScreenFrame : offScreenFrame;
    
    //        animatingView.frame = initialFrame;
    
    animatingView.frame = finalFrame;
    
    //    if (self.isPresentation) {
    //        animatingView.frame = finalFrame;
    //    } else {
    //        animatingView.frame = initialFrame;
    //        animatingView.backgroundColor = [UIColor whiteColor];
    //    }
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:10 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (!self.isPresentation) {
            animatingView.frame = finalFrame;
        }
        
        animatingView.alpha = self.isPresentation? 1.0:0.0;
        if (self.isPresentation) {
            wView.frame = CGRectMake((SCREEN_WIDTH-width)/2, margin_v, width, containerView.frame.size.height);
        } else {
            wView.frame = CGRectMake((SCREEN_WIDTH-width)/2, SCREEN_HEIGHT, width, containerView.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        //        if (!self.isPresentation) {
        [fromView removeFromSuperview];
        //        }
        
        [wView removeFromSuperview];
        
        [transitionContext completeTransition:YES];
    }];
}

@end