//
//  AgileMenuView.m
//  BodyToDress
//
//  Created by Michal Cisarik on 5/22/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "AgileDebugMenuView.h"
#import "AutolayoutMacros.h"
#import "Macros.h"
#import "ADWebView.h"

@implementation AgileDebugMenuView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"analytical.png"]];

        _imgWebView = [[UIWebView alloc]init];
        
//        Class ADWebView = NSClassFromString(@"ADWebView");
//        _imgWebView = (UIWebView *)[[ADWebView alloc] initWithFrame:self.window.bounds];
//        [_imgWebView setWebGLEnabled:YES];
//        
        [self addSubview:_imgWebView];
        
        UIFontDescriptor *baseFont=FONT;
        UIFontDescriptor *boldFont=[baseFont fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
       
        _updateButton=[AgileButton bdButtonWithType:AgileClearButton];
        
        _updateButton.titleLabel.font = [UIFont fontWithDescriptor:boldFont size:46];
        _updateButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_updateButton setTitle:@"↪︎" forState:UIControlStateNormal];
        _updateButton.alpha = 1;
        
        [self addSubview:_updateButton];
        
        _continueButton=[AgileButton bdButtonWithType:AgileClearButton];
        
        _continueButton.titleLabel.font = [UIFont fontWithDescriptor:boldFont size:36];
        _continueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_continueButton setTitle:@"➔" forState:UIControlStateNormal];
        _continueButton.alpha = 1;
        
        [self addSubview:_continueButton];
        
        
        NSDictionary *metrics = @{
                                  @"LOGO_H_OFFSET" : @40
                                  };
        
        
        
        TMALVariableBindingsAMNO(_updateButton,_imgWebView,_continueButton);
        
        TMAL_ADDS_VISUALM( @"V:|-122-[_updateButton(==20)]", metrics );
        TMAL_ADDS_VISUALM( @"H:|-LOGO_H_OFFSET-[_updateButton]-LOGO_H_OFFSET-|", metrics);
        
        TMAL_ADDS_VISUAL( @"V:|-0-[_imgWebView]-0-|");
        TMAL_ADDS_VISUAL( @"H:|-0-[_imgWebView]-0-|");
        
        TMAL_ADDS_VISUAL( @"V:[_continueButton(==20)]-46-|");
        TMAL_ADDS_VISUALM( @"H:|-LOGO_H_OFFSET-[_continueButton]-LOGO_H_OFFSET-|", metrics);

    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
