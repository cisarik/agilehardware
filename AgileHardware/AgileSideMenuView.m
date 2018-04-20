//
//  AgileSideMenuView.m
//  BodyToDress
//
//  Created by Michal Cisarik on 5/27/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "AgileSideMenuView.h"
#import "AgileTools.h"
#import "Macros.h"
#import "AutolayoutMacros.h"
#import "AgileGradient.h"
#import "AlphaGradientView.h"

@interface AgileSideMenuView() {
    UIImageView *_patternView;
    UIImageView *_patternViewLeft;
}
@property (strong,nonatomic)UIImageView* logoImageView;
@end

@implementation AgileSideMenuView

- (id)init
{
    self = [super init];
    if (self) {
        
//        _patternViewLeft=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AgileHardwareSideMenuBackgroundLeft"]];
//        _patternViewLeft.contentMode = UIViewContentModeScaleAspectFill;
//        _patternViewLeft.alpha=0.9;
//        //[_patternView setFrame:self.frame];
//        [self addSubview:_patternViewLeft];
        
        _patternView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AgileHardwareSideMenuBackground"]];
        _patternView.contentMode = UIViewContentModeScaleAspectFill;
        //[_patternView setFrame:self.frame];
        [self addSubview:_patternView];
        
        
//        
//       
//        _patternView = [[UIView alloc]initWithFrame:self.frame];
//        _patternView.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"analytical.png"]];
//        [self addSubview:_patternView];
//        
//        AlphaGradientView* gradient = [[AlphaGradientView alloc] initWithFrame:
//                                       CGRectMake(self.frame.size.width - 150, 0, 150,
//                                                  self.frame.size.height)];
//        x
//        gradient.color = [UIColor yellowColor];
//        gradient.direction = GRADIENT_RIGHT;
//        [_patternView addSubview:gradient];
//        
//        
//        AgileGradient *background = [[AgileGradient alloc]init];
//        [self addSubview:background];
////
//        [self bringSubviewToFront:gradient];
//        //[self addSubview:_patternView];
//        
////        
        TMALVariableBindingsAMNO(_patternView);
        
        TMAL_ADDS_VISUAL( @"V:|-0-[_patternView]-0-|" );
        TMAL_ADDS_VISUAL( @"H:|-0-[_patternView]-0-|" );
        
        
 
    }
    return self;
}


@end
