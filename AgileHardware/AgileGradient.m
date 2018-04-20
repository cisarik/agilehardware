//
//  AgileGradient.m
//  BodyToDress
//
//  Created by Michal Cisarik on 6/8/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "AgileGradient.h"
#import "AgileTools.h"

#import <QuartzCore/QuartzCore.h>

@interface AgileGradient() {
    UIView *_patternView;
}
@end

@implementation AgileGradient


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //_patternView = [[UIView alloc]init];
    //self.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"analytical.png"]];
    //[self addSubview:_patternView];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *startColor=[UIColor whiteColor];
    UIColor *endColor=[UIColor clearColor];
    drawLinearGradient(context, [startColor CGColor], [endColor CGColor], self.bounds);
}


@end
