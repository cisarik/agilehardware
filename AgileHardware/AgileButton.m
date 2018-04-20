//
//  AgileButton.m
//  BodyToDress
//
//  Created by Michal Cisarik on 5/18/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "AgileButton.h"
#import "Macros.h"
#import "AutolayoutMacros.h"

@interface AgileButton()
@property UIImageView *_removeItemImageView;
@property UIView *_removeItemView;

@end


@implementation AgileButton

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    //NSLog(@"clicked");
//    return self;
//}

+ (AgileButton*)bdButtonWithType:(AgileButtonType)buttonType {
    
    AgileButton *newButton=[AgileButton buttonWithType:UIButtonTypeCustom];
    
    UIFontDescriptor *baseFont=FONT;
    UIFontDescriptor *boldFont=[baseFont fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    newButton.titleLabel.font = [UIFont fontWithDescriptor:baseFont size:12];
    newButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    switch (buttonType) {
            
        case AgileRemoveItemButton: {
            
            newButton._removeItemView=[[UIView alloc]init];
            [newButton._removeItemView setBackgroundColor:BACKGROUND_COLOR];
            [newButton._removeItemView.layer setCornerRadius:10];
            newButton._removeItemView.clipsToBounds = YES;
            
            newButton._removeItemImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed: @"icon_modal_close_white.png"]];
            
            [newButton._removeItemView addSubview:newButton._removeItemImageView];
            
            
            newButton.alpha=0.0f;
            newButton.backgroundColor=[UIColor clearColor];
            [newButton addSubview:newButton._removeItemView];
            
            break;
        }
            
        case AgileClearButton: {
            
            newButton.backgroundColor=[UIColor clearColor];
            newButton.titleLabel.textColor = [UIColor blackColor];
            
            break;
        }
            
           }
    
    [newButton setAutolayout:buttonType];
    
    return newButton;
}

-(void)setAutolayout:(AgileButtonType)type{
    switch (type) {
        case AgileRemoveItemButton: {
            
            UIView *removeItemView=self._removeItemView;
            UIImageView *removeItemImageView=self._removeItemImageView;
            
            TMALVariableBindingsAMNO( removeItemView,removeItemImageView );
            
            TMAL_ADDS_VISUAL( @"H:|-6-[removeItemImageView(==8)]");
            TMAL_ADDS_VISUAL( @"V:|-6-[removeItemImageView(==8)]" );
            
            TMAL_ADDS_VISUAL( @"H:|-10-[removeItemView(==20)]");
            TMAL_ADDS_VISUAL( @"V:|-0-[removeItemView(==20)]" );
            
            break;
        }
        default:
            break;
    }
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        switch (self.bdButtonType) {
                
                
            case AgileClearButton:
                self.backgroundColor=[UIColor blackColor];
                self.tintColor = [UIColor blackColor];
                break;
            default:
                break;
        }
    } else {
        switch (self.bdButtonType) {
                
                
            case AgileClearButton:
                self.backgroundColor=[UIColor clearColor];
                self.tintColor = [UIColor blackColor];
                break;
            default:
                break;
        }
    }
}
@end
