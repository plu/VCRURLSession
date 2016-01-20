//
//  VCRURLSessionRecorder.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSession.h"
#import "VCRURLSessionLogger.h"
#import "VCRURLSessionRecorder.h"
#import "VCRURLSessionRecorderDelegate.h"

static NSString *VCRURLSessionRecorderTaskKey = @"VCRURLSessionRecorderTaskKey";
static id<VCRURLSessionRecorderDelegate> VCRURLSessionRecorderSharedDelegate = nil;

@interface VCRURLSessionRecorder () <NSURLSessionDelegate>

@property (nonatomic) NSURLSession *session;

@end

@implementation VCRURLSessionRecorder

+ (void)load
{
    [self registerClass:self];
}

#pragma mark - Public methods

+ (BOOL)isRecording
{
    return VCRURLSessionRecorderSharedDelegate != nil;
}

+ (void)startRecordingWithDelegate:(id<VCRURLSessionRecorderDelegate>)delegate
{
    VCRURLSessionRecorderSharedDelegate = delegate;
}

+ (id<VCRURLSessionRecorderDelegate>)stopRecording
{
    id<VCRURLSessionRecorderDelegate> delegate = VCRURLSessionRecorderSharedDelegate;
    VCRURLSessionRecorderSharedDelegate = nil;
    return delegate;
}

#pragma mark - Overridden methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [self isRecording];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    return [super initWithRequest:request cachedResponse:nil client:client];
}

- (void)startLoading
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];

    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];

    NSURLSessionTask *task = [self.session
        dataTaskWithRequest:self.request
          completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
              NSTimeInterval responseTime = [NSDate timeIntervalSinceReferenceDate] - startTime;

              if (response) {
                  [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
              }
              if (data) {
                  [self.client URLProtocol:self didLoadData:data];
              }
              if (error) {
                  [self.client URLProtocol:self didFailWithError:error];
              }
              [self.client URLProtocolDidFinishLoading:self];

              [[self class] removePropertyForKey:VCRURLSessionRecorderTaskKey inRequest:self.request.mutableCopy];

              [VCRURLSessionLogger log:VCRURLSessionLogLevelInfo
                               message:@"[R] %zd %@ (%.2fms)", ((NSHTTPURLResponse *)response).statusCode, self.request.URL, (responseTime * 1000)];
              [VCRURLSessionRecorderSharedDelegate recordRequest:self.request
                                                    responseTime:responseTime
                                                        response:(NSHTTPURLResponse *)response
                                                            data:data
                                                           error:error];
          }];

    [[self class] setProperty:task forKey:VCRURLSessionRecorderTaskKey inRequest:self.request.mutableCopy];
    [task resume];
}

- (void)stopLoading
{
    NSURLSessionTask *task = [[self class] propertyForKey:VCRURLSessionRecorderTaskKey inRequest:self.request];
    [task cancel];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
                   task:(NSURLSessionTask *)task
    didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
      completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if (completionHandler) {
        if (challenge.previousFailureCount > 0) {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge,
                              [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
        }
        else {
            completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
        }
    }
}

@end
