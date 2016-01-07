//
//  VCRURLSession.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VCRURLSessionCassette;

NS_ASSUME_NONNULL_BEGIN

@interface VCRURLSession : NSObject

+ (BOOL)isRecording;
+ (void)startRecordingOnCassette:(VCRURLSessionCassette *)cassette;
+ (void)stopRecording;

+ (BOOL)isReplaying;
+ (void)startReplayingWithCassette:(VCRURLSessionCassette *)cassette;
+ (void)stopReplaying;

+ (NSURLSession *)prepareURLSession:(NSURLSession *)session;

@end

NS_ASSUME_NONNULL_END
