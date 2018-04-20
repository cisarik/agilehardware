//
//  AgileMenuView.h
//  BodyToDress
//
//  Created by Michal Cisarik on 5/22/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "AgileButton.h"

@interface AgileDebugMenuView : UIView
@property AgileButton *updateButton;
@property AgileButton *continueButton;
@property(nonatomic, strong)UIWebView *imgWebView;
@end
