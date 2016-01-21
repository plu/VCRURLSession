//
//  VCRURLSessionPlayer.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionLogger.h"
#import "VCRURLSessionPlayer.h"
#import "VCRURLSessionPlayerDelegate.h"
#import "VCRURLSessionRecord.h"

static id<VCRURLSessionPlayerDelegate> VCRURLSessionPlayerSharedDelegate = nil;
static VCRURLSessionReplayMode VCRURLSessionPlayerSharedMode = VCRURLSessionReplayModeNormal;

@implementation VCRURLSessionPlayer

+ (void)load
{
    [self registerClass:self];
}

#pragma mark - Public methods

+ (BOOL)isReplaying
{
    return VCRURLSessionPlayerSharedDelegate != nil;
}

+ (void)startReplayingWithDelegate:(id<VCRURLSessionPlayerDelegate>)delegate mode:(VCRURLSessionReplayMode)mode
{
    VCRURLSessionPlayerSharedDelegate = delegate;
    VCRURLSessionPlayerSharedMode = mode;
}

+ (void)stopReplaying
{
    VCRURLSessionPlayerSharedDelegate = nil;
}

#pragma mark - Overridden methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    switch (VCRURLSessionPlayerSharedMode) {
    // Handle only matching requests
    case VCRURLSessionReplayModeNormal:
        return [VCRURLSessionPlayerSharedDelegate recordForRequest:request] != nil && [self isReplaying];
    // Handle all requests as long as the delegate is set
    case VCRURLSessionReplayModeStrict:
        return [self isReplaying];
    }
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
    VCRURLSessionRecord *record = [VCRURLSessionPlayerSharedDelegate recordForRequest:self.request];
    if (!record) {
        [VCRURLSessionLogger log:VCRURLSessionLogLevelError message:@"[E] RecordNotFound: %@ %@", self.request.HTTPMethod, self.request.URL];

        NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNotConnectedToInternet userInfo:@{NSURLErrorKey : self.request.URL}];
        [self.client URLProtocol:self didFailWithError:error];
        return;
    }

    record.played = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(record.responseTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [VCRURLSessionLogger
                log:VCRURLSessionLogLevelInfo
            message:@"[P] %zd %@ %@ (%.2fms)", record.response.statusCode, self.request.HTTPMethod, self.request.URL, (record.responseTime * 1000)];

        if (record.error) {
            [self.client URLProtocol:self didFailWithError:record.error];
            return;
        }

        if (record.response) {
            [self.client URLProtocol:self didReceiveResponse:record.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        }

        if (record.data) {
            [self.client URLProtocol:self didLoadData:record.data];
        }

        [self.client URLProtocolDidFinishLoading:self];
    });
}

- (void)stopLoading
{
}

@end
