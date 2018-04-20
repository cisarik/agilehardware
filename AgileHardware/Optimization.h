//
//  Optimization.h
//  SymbolicRegression
//
//  Created by Michal Cisarik on 7/12/14.
//  Copyright (c) 2014 Michal Cisarik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFS.h"

@interface Optimization : NSObject 

@property(readwrite) double al_;
@property(readwrite) double au_;
@property(readwrite) double bl_;
@property(readwrite) double bu_;

-(id) initBlindSearchWithGFS:(GFS*)fs;
-(void) search;
-(void) free;

@end
