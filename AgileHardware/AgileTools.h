//
//  Tools.h
//  BodyToDress
//
//  Created by Michal Cisarik on 5/22/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HEX(x) [AgileTools colorWithHexString: x]


#define degreesToRadians(x) (M_PI * x / 180.0)

// Tools object:
@interface AgileTools : NSObject
+ (NSString *)sha256:(NSString *)input;
+(UIColor*)colorWithHexString:(NSString*)hex;
+ (UIImage *)imageFromView:(UIView *)view;
+(BOOL) validEmail:(NSString *)tempMail;
@end

// CoreGraphic and other C - functions:
void drawLinearGradient(CGContextRef context, CGColorRef color1, CGColorRef color2, CGRect rect);