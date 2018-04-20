//
//  TwoStepTransition.m
//  03
//
//  Created by Michal Cisarik on 3/11/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "TwoStepTransition.h"

@implementation TwoStepTransition
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC =[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC =[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    __block CGRect presentedFrame =[transitionContext initialFrameForViewController:fromVC];
    
    [UIView animateKeyframesWithDuration:1.0f delay:0.0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            fromVC.view.frame=CGRectMake(presentedFrame.origin.x, presentedFrame.origin.y, presentedFrame.size.width, presentedFrame.size.height);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            presentedFrame.origin.y +=CGRectGetHeight(presentedFrame)+20;
            fromVC.view.frame=presentedFrame;
            fromVC.view.transform=CGAffineTransformMakeRotation(0.2);
        }];
        
    } completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
    }
     ];
}
@end
