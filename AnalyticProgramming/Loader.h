//
//  Loader.h
//  MSAP
//
//  Created by Michal Cisarik on 2/23/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFS.h"
#import "DDMathParser.h"
#import "DDMathStringTokenizer.h"
#import "DDMathOperator.h"

@interface Loader : NSObject {
    
    NSMutableDictionary *configuration;
    IN* input;
}
@property NSMutableDictionary* configuration;
@property IN* input;
-(IN*)generateInput:(NSString*)inputDescription;

- (id)initWithInput:(NSString*)inputDescription settings:(NSDictionary*)settings;


@end

