//
//  VCRURLSessionPlayer.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionPlayer.h"
#import "VCRURLSessionPlayerDelegate.h"
#import "VCRURLSessionRecord.h"

static id<VCRURLSessionPlayerDelegate> VCRURLSessionPlayerSharedDelegate = nil;

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

+ (void)startReplayingWithDelegate:(id<VCRURLSessionPlayerDelegate>)delegate
{
    VCRURLSessionPlayerSharedDelegate = delegate;
}

+ (void)stopReplaying
{
    VCRURLSessionPlayerSharedDelegate = nil;
}

#pragma mark - Overridden methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [self isReplaying] && [VCRURLSessionPlayerSharedDelegate recordForRequest:request] != nil;
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
        return;
    }

    record.played = YES;
    if (record.error) {
        [self.client URLProtocol:self didFailWithError:record.error];
        return;
    }

    [self.client URLProtocol:self didReceiveResponse:record.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:record.data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
}

@end
