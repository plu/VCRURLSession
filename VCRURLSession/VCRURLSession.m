//
//  VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSession.h"
#import "VCRURLSessionCassette.h"
#import "VCRURLSessionPlayer.h"
#import "VCRURLSessionPlayerDelegate.h"
#import "VCRURLSessionRecord.h"
#import "VCRURLSessionRecorder.h"
#import "VCRURLSessionRecorderDelegate.h"
#import "VCRURLSessionSampler.h"

@implementation VCRURLSession

+ (NSURLSession *)prepareURLSession:(NSURLSession *)session
                           delegate:(id<NSURLSessionDelegate> _Nullable)delegate
                      delegateQueue:(NSOperationQueue *_Nullable)queue;
{
    NSURLSessionConfiguration *configuration = session.configuration.copy;
    NSArray *classes = @[ [VCRURLSessionSampler class], [VCRURLSessionPlayer class], [VCRURLSessionRecorder class] ];
    configuration.protocolClasses = [classes arrayByAddingObjectsFromArray:configuration.protocolClasses];
    return [NSURLSession sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
}

+ (NSURLSession *)prepareURLSession:(NSURLSession *)session
{
    return [self prepareURLSession:session delegate:nil delegateQueue:nil];
}

+ (void)setStaticResponseHandler:(VCRURLSessionResponse *_Nullable (^)(NSURLRequest *request))handler
{
    [VCRURLSessionSampler setStaticResponseHandler:handler];
}

#pragma mark - Public recording methods

+ (BOOL)isRecording
{
    return [VCRURLSessionRecorder isRecording];
}

+ (void)startRecordingOnCassette:(VCRURLSessionCassette *)cassette
{
    [VCRURLSessionRecorder startRecordingWithDelegate:cassette];
}

+ (VCRURLSessionCassette *)stopRecording
{
    id<VCRURLSessionRecorderDelegate> delegate = [VCRURLSessionRecorder stopRecording];
    return (VCRURLSessionCassette *)delegate;
}

#pragma mark - Public replaying methods

+ (BOOL)isReplaying
{
    return [VCRURLSessionPlayer isReplaying];
}

+ (void)startReplayingWithCassette:(VCRURLSessionCassette *)cassette mode:(VCRURLSessionReplayMode)mode
{
    return [VCRURLSessionPlayer startReplayingWithDelegate:cassette mode:mode];
}

+ (void)stopReplaying
{
    [VCRURLSessionPlayer stopReplaying];
}

@end
