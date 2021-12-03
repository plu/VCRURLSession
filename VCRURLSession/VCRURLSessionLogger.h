//
//  VCRURLSessionLogger.h
//  VCRURLSession
//
//  Created by Plunien, Johannes(AWF) on 20/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import <Foundation/Foundation.h>

/**
 *  VCRURLSessionLogLevel
 */
typedef NS_ENUM(NSUInteger, VCRURLSessionLogLevel) {
    /**
     *  Does not log anything.
     */
    VCRURLSessionLogLevelNone,
    /**
     *  Logs errors.
     */
    VCRURLSessionLogLevelError,
    /**
     *  Logs recorded and replayed responses (URL and statusCode).
     */
    VCRURLSessionLogLevelInfo,
};

@interface VCRURLSessionLogger : NSObject

+ (void)setLogLevel:(VCRURLSessionLogLevel)logLevel;
+ (void)log:(VCRURLSessionLogLevel)logLevel message:(NSString *)message, ...;

@end

#endif
