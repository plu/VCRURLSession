//
//  VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSession.h"
#import "VCRURLSessionRecorder.h"
#import "VCRURLSessionRecorderDelegate.h"

@interface VCRURLSession () <VCRURLSessionRecorderDelegate>

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

#pragma mark - Public methods

+ (BOOL)isRecording
{
    return [VCRURLSessionRecorder isRecording];
}

+ (void)startRecording
{
    [VCRURLSessionRecorder startRecordingWithDelegate:[VCRURLSession sharedSession]];
}

+ (void)stopRecording
{
    [VCRURLSessionRecorder stopRecording];
}

#pragma mark - VCRURLSessionRecorderDelegate

- (void)recordRequest:(NSURLRequest *)request response:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error
{
}

@end
