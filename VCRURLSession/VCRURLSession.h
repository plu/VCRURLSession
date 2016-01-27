//
//  VCRURLSession.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionCassette.h"
#import "VCRURLSessionLogger.h"
#import "VCRURLSessionReplayMode.h"
#import "VCRURLSessionResponse.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Record and replay your test suite's HTTP requests and responses.
 */
@interface VCRURLSession : NSObject

/**
 *  Determine current state of recording (on/off).
 *
 *  @return true if currently recording to a cassette.
 */
+ (BOOL)isRecording;

/**
 *  Start recording HTTP requests and responses.
 *
 *  @param cassette an instance of `VCRURLSessionCassette` to record requests to.
 */
+ (void)startRecordingOnCassette:(VCRURLSessionCassette *)cassette;

/**
 *  Stop recording HTTP requests and responses.
 *
 *  @return `VCRURLSessionCassette` instance it was recording to.
 */
+ (VCRURLSessionCassette *_Nullable)stopRecording;

/**
 *  Determine current state of replaying (on/off).
 *
 *  @return true if currently replaying from a cassette.
 */
+ (BOOL)isReplaying;

/**
 *  Start replaying HTTP responses from a cassette.
 *
 *  @param cassette `VCRURLSessionCassette` instance.
 *  @param mode     `VCRURLSessionReplayMode` replaying mode.
 */
+ (void)startReplayingWithCassette:(VCRURLSessionCassette *)cassette mode:(VCRURLSessionReplayMode)mode;

/**
 *  Stop replyaing HTTP responses from a cassette.
 */
+ (void)stopReplaying;

/**
 *  Prepare a `NSURLSession` for recording/replaying HTTP requests and responses.
 *
 *  @param session `NSURLSession` instance
 *
 *  @return `NSURLSession` instance
 */
+ (NSURLSession *)prepareURLSession:(NSURLSession *)session;

/**
 *  Prepare a `NSURLSession` for recording/replaying HTTP requests and responses.
 *
 *  @param session `NSURLSession` instance
 *  @param delegate `id<NSURLSessionDelegate>` instance
 *  @param delegateQueue `NSOperationQueue` instance
 *
 *  @return `NSURLSession` instance
 */
+ (NSURLSession *)prepareURLSession:(NSURLSession *)session
                           delegate:(id<NSURLSessionDelegate> _Nullable)delegate
                      delegateQueue:(NSOperationQueue *_Nullable)queue;

/**
 *  This will enable recording/replaying HTTP requests and responses for the old
 *  `NSURLConnection` APIs.
 */
+ (void)registerProtocolClasses;

/**
 *  This will disable recording/replaying HTTP requests and responses for the old
 *  `NSURLConnection` APIs.
 */
+ (void)unregisterProtocolClasses;

/**
 *  Set a block that returns static responses.
 *
 *  @param handler a block that returns `VCRURLSessionResponse` instances.
 */
+ (void)setStaticResponseHandler:(VCRURLSessionResponse *_Nullable (^)(NSURLRequest *request))handler;

/**
 *  Change the `logLevel`, defaults to: VCRURLSessionLogLevelNone
 *  Logging is only enabled in `DEBUG` builds, no matter what `logLevel` is set.
 *
 *  @param logLevel `VCRURLSessionLogLevel`
 */
+ (void)setLogLevel:(VCRURLSessionLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
