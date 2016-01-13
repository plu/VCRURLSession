//
//  VCRURLSession.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionCassette.h"
#import "VCRURLSessionReplayMode.h"
#import "VCRURLSessionResponse.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCRURLSession : NSObject

+ (BOOL)isRecording;
+ (void)startRecordingOnCassette:(VCRURLSessionCassette *)cassette;
+ (VCRURLSessionCassette *_Nullable)stopRecording;

+ (BOOL)isReplaying;
+ (void)startReplayingWithCassette:(VCRURLSessionCassette *)cassette mode:(VCRURLSessionReplayMode)mode;
+ (void)stopReplaying;

+ (NSURLSession *)prepareURLSession:(NSURLSession *)session;
+ (void)setStaticResponseHandler:(VCRURLSessionResponse *_Nullable (^)(NSURLRequest *request))handler;

@end

NS_ASSUME_NONNULL_END
