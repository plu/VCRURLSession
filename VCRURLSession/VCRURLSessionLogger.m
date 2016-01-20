//
//  VCRURLSessionLogger.m
//  VCRURLSession
//
//  Created by Plunien, Johannes(AWF) on 20/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionLogger.h"

static VCRURLSessionLogLevel VCRURLSessionLoggerLogLevel = VCRURLSessionLogLevelNone;

@implementation VCRURLSessionLogger

+ (void)setLogLevel:(VCRURLSessionLogLevel)logLevel
{
    VCRURLSessionLoggerLogLevel = logLevel;
}

+ (void)log:(VCRURLSessionLogLevel)logLevel message:(NSString *)message, ...
{
    if (logLevel > VCRURLSessionLoggerLogLevel && logLevel != VCRURLSessionLogLevelNone) {
        return;
    }

#ifdef DEBUG
    va_list args;
    va_start(args, message);
    message = [@"[VCR] " stringByAppendingString:message];
    NSLogv(message, args);
    va_end(args);
#endif
}

@end
