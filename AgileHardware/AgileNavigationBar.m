//
//  AgileNavigationBar.m
//  BodyToDress
//
//  Created by Michal Cisarik on 6/9/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "AgileNavigationBar.h"
#import "Macros.h"

@implementation AgileNavigationBar

+ (void)initialize {
    UIFontDescriptor *baseFont = FONT;
    
    UIImage *back = [UIImage imageNamed:@"icon_nav_back"];
    
    const CGFloat ArrowLeftCap = back.size.width-2;
    back = [back stretchableImageWithLeftCapWidth:ArrowLeftCap
                                     topCapHeight:0];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:back
                                                                                                  forState:UIControlStateNormal
                                                                                                barMetrics:UIBarMetricsDefault];
    
    const CGFloat TextOffset = 3.0f;
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonTitlePositionAdjustment:UIOffsetMake(TextOffset, -100)
                                                                                                     forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonTitlePositionAdjustment:UIOffsetMake(TextOffset, -100)
                                                                                                     forBarMetrics:UIBarMetricsCompact];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithDescriptor:baseFont size:13]} forState:UIControlStateNormal];
    
    
    [[UINavigationBar appearance] setBarTintColor:BACKGROUND_COLOR];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] , NSFontAttributeName:[UIFont fontWithDescriptor:baseFont size:14] } ];
    
    //
    //    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
    //                                                           [UIColor whiteColor], UITextAttributeTextColor,
    //                                                          // [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
    //                                                           //[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
    //                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], UITextAttributeFont, nil]];
    
    
}

- (void)customize {
    //    UIImage *navBarBg = [UIImage imageNamed:@"navigationbar.png"];
    //    [self setBackgroundImage:navBarBg forBarMetrics:UIBarMetricsDefault];
    //[self setBarTintColor:BACKGROUND_COLOR];
    
}

@end
