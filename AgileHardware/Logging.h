//
//  Logging.h
//  AgileHardware
//
//  Created by Michal Cisarik on 6/17/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#ifndef AgileHardware_Logging_h
#define AgileHardware_Logging_h

#import <DDLog.h>
#import <DDTTYLogger.h>
#import <DDFileLogger.h>
#import <DDASLLogger.h>

#if DEBUG
static const int ddLogLevel= LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define NSLog DDLogVerbose

#endif
