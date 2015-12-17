//
//  VVChromeTransitioner.m
//
//  Copyright (c) 2015 Wei Wang (http://onevcat.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "PIETransitioning_CarouselHome.h"

@implementation PIETransitioning_CarouselHome

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = [transitionContext containerView];
    
    
    if ( self.isPresentation) {
        [containerView addSubview:toView];
        UIViewController *animatingViewController = toViewController;
        UIView *animatingView = animatingViewController.view;
        animatingView.alpha = 0.0;
        
        CGRect onScreenFrame = [transitionContext finalFrameForViewController:animatingViewController];
        CGRect offScreenFrame = CGRectOffset(onScreenFrame, 0, onScreenFrame.size.height);
        animatingView.frame = offScreenFrame;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:2 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            animatingView.frame = onScreenFrame;
            animatingView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 animations:^{
                animatingView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.8];
            }];

            [transitionContext completeTransition:YES];
        }];
    } else {
        UIViewController *animatingViewController = fromViewController;
        UIView *animatingView = animatingViewController.view;
        animatingView.alpha = 1.0;
        
        CGRect onScreenFrame = [transitionContext finalFrameForViewController:animatingViewController];
        CGRect offScreenFrame = CGRectOffset(onScreenFrame, 0, onScreenFrame.size.height);
        animatingView.frame = onScreenFrame;
        animatingView.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:2 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
            animatingView.frame = offScreenFrame;
            animatingView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }


    
}



//
//    CGFloat scale_h = (414-40)/414.0;
//    CGFloat scale_v = (736-94)/736.0;
//
//    CGFloat width  = SCREEN_WIDTH *scale_h;
//    CGFloat height = SCREEN_HEIGHT*scale_v;
//    CGFloat margin_v = (SCREEN_HEIGHT - height);
//    UIView * wView = [UIView new];


//    if (self.isPresentation) {
//        wView.frame = CGRectMake((SCREEN_WIDTH-width)/2, SCREEN_HEIGHT, width, containerView.frame.size.height);
//    } else {
//        wView.frame = CGRectMake((SCREEN_WIDTH-width)/2, margin_v, width, containerView.frame.size.height);
//    }
//    wView.layer.cornerRadius = 10;
//    wView.clipsToBounds = YES;

//    wView.backgroundColor = [UIColor whiteColor];

@end
