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

@interface VCRURLSession ()

@property (nonatomic) VCRURLSessionCassette *cassette;

@end

@implementation VCRURLSession

+ (instancetype)sharedSession
{
    static VCRURLSession *sharedSession;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [[self alloc] init];
    });
    return sharedSession;
}

+ (NSURLSession *)prepareURLSession:(NSURLSession *)session
{
    NSURLSessionConfiguration *configuration = session.configuration.copy;
    configuration.protocolClasses =
        [@[ [VCRURLSessionPlayer class], [VCRURLSessionRecorder class] ] arrayByAddingObjectsFromArray:configuration.protocolClasses];
    return [NSURLSession sessionWithConfiguration:configuration];
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

+ (void)stopRecording
{
    [VCRURLSessionRecorder stopRecording];
}

#pragma mark - Public replaying methods

+ (BOOL)isReplaying
{
    return [VCRURLSessionPlayer isReplaying];
}

+ (void)startReplayingWithCassette:(VCRURLSessionCassette *)cassette
{
    return [VCRURLSessionPlayer startReplayingWithDelegate:cassette];
}

+ (void)stopReplaying
{
    [VCRURLSessionPlayer stopReplaying];
}

@end
