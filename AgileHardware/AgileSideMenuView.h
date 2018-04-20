//
//  AgileSideMenuView.h
//  BodyToDress
//
//  Created by Michal Cisarik on 5/27/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgileButton.h"

@interface AgileSideMenuView : UIView
@property (strong,nonatomic)AgileButton *myWardrobeButton;
@property (strong,nonatomic)AgileButton *outfitsButton;
@property (strong,nonatomic)AgileButton *outfitNewButton;
@property (strong,nonatomic)AgileButton *settingsButton;
@property (strong,nonatomic)AgileButton *logoutButton;
@end
