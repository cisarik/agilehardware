//
//  DismissGravity.m
//  03.02
//
//  Created by Michal Cisarik on 3/12/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "DismissGravity.h"

@implementation DismissGravity

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC=[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.animator=[[UIDynamicAnimator alloc]initWithReferenceView:[transitionContext containerView]];
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc]initWithItems:@[fromVC.view]];
    gravity.gravityDirection=CGVectorMake(0, -12);
    [self.animator addBehavior:gravity];
    
    gravity.action=^{
        if (!CGRectIntersectsRect(fromVC.view.frame, [[transitionContext containerView]frame])) {
            [self.animator removeAllBehaviors];
            [transitionContext completeTransition:YES];
        }
    };
}
@end
