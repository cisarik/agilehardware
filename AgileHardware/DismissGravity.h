//
//  DismissGravity.h
//  03.02
//
//  Created by Michal Cisarik on 3/12/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DismissGravity : NSObject <UIViewControllerAnimatedTransitioning,UIDynamicAnimatorDelegate>
@property (strong,nonatomic)UIDynamicAnimator *animator;
@property (strong,nonatomic)id<UIViewControllerContextTransitioning> transitionContext;
@end
