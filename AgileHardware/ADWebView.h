//
//  ADWebView.h
//  AgileHardware
//
//  Created by Michal Cisarik on 6/12/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface ADWebView : UIWebView
{
    BOOL _webGLEnabled;
}
@property(nonatomic) BOOL webGLEnabled;
@end
