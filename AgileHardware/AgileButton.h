//
//  AgileButton.h
//  BodyToDress
//
//  Created by Michal Cisarik on 5/18/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AgileLoginButton,
    AgileClearButton,
    AgileGoogleButton,
    AgileFacebookButton,
    AgileLoginSubmitButton,
    AgileSideMenuButton,
    AgileTableViewLikeButton,
    AgileTableViewLikeButtonGray,
    AgileColorsButton,
    AgileRemoveItemButton
} AgileButtonType;

/*!
 * @interface AgileButton
 * @brief Button used across whole UI. It's type is defined by AgileButtonType typedef
 */
@interface AgileButton : UIButton

// Strong reference of Button's type
@property (nonatomic)AgileButtonType bdButtonType;


/*!
 * @brief Factory class method for AgileButtons
 * @discussion One interface for all UI's buttons?
 * @param buttonType Type of AgileButton
 * @warning Animations are not available after using AgileButton Factory
 * @return Created AgileButton
 */
+ (AgileButton*)bdButtonWithType:(AgileButtonType)buttonType;
/* TODO:
 
 */
@end
