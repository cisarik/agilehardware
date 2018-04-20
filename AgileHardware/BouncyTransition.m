#import "BouncyTransition.h"

@implementation BouncyTransition
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.7f;
}

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self.transitionContext completeTransition:YES];
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    self.transitionContext=transitionContext;
    
    UIViewController *toVC =[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect fromVCStartFrame=[transitionContext initialFrameForViewController:fromVC];
    CGRect toVCStartFrame=CGRectMake(0, -CGRectGetHeight(fromVCStartFrame), CGRectGetWidth(fromVCStartFrame), CGRectGetHeight(fromVCStartFrame));
    
    toVC.view.frame=toVCStartFrame;
    
    [[transitionContext containerView]addSubview:toVC.view];
    
    self.animator=[[UIDynamicAnimator alloc]initWithReferenceView:[transitionContext containerView]];
    
    UIGravityBehavior *gravity=[[UIGravityBehavior alloc]initWithItems:@[toVC.view]];
    gravity.gravityDirection=CGVectorMake(0, 2);
    [self.animator addBehavior:gravity];
    
    
    UICollisionBehavior *collision=[[UICollisionBehavior alloc]initWithItems:@[toVC.view]];
    
    [collision addBoundaryWithIdentifier:@"bottomEdge" fromPoint:CGPointMake(0, CGRectGetMaxY(fromVC.view.frame)) toPoint:CGPointMake(CGRectGetMaxX(fromVC.view.frame), CGRectGetMaxY(fromVC.view.frame))];

    
    [self.animator addBehavior:collision];
    
    self.animator.delegate=self;
    
    /*
    
    [[transitionContext containerView]addSubview:toVC.view];
    
    __block CGRect fullFrame = [transitionContext initialFrameForViewController:fromVC];
    
    __block CGFloat height = CGRectGetHeight(fullFrame);
    
    toVC.view.frame=CGRectMake(fullFrame.origin.x+20, height+16+20, CGRectGetWidth(fullFrame)-40, height-40);
    
    
    //[UIView transitionFromView:fromVC toView:toVC duration:[self transitionDuration:transitionContext] options:UIViewAnimationOptionCurveEaseOut completion:^(BOOL finished){[transitionContext completeTransition:YES];} ];
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{toVC.view.frame =CGRectMake(20, 20, CGRectGetWidth(fullFrame)-40, height-40);} completion:^(BOOL finished){[transitionContext completeTransition:YES];}];
     */
    
}
@end