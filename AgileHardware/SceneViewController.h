//
//  SceneViewController.h
//  AgileHardware
//
//  Created by Michal Cisarik on 6/17/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
//#import <OpenGLES.h>

@interface SceneViewController : UIViewController <SCNSceneRendererDelegate>
-(void)viewDidLoad;
@end
