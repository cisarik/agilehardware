//
//  ElementScene.h
//  AgileHardware
//
//  Created by Michal Cisarik on 6/17/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@class Loader;
@interface ElementScene : SCNScene
- (id)initWithLoader:(Loader*)loader;
@end
