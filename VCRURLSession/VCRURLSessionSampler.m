//
//  VCRURLSessionSampler.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 11/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import "VCRURLSessionSampler.h"
#import "VCRURLSessionResponse.h"

VCRURLSessionResponse * (^VCRURLSessionStaticResponseHandler)(NSURLRequest *request) = nil;

@implementation VCRURLSessionSampler

+ (void)load
{
    [self registerClass:self];
}

+ (void)setStaticResponseHandler:(VCRURLSessionResponse *_Nullable (^)(NSURLRequest *))handler
{
    VCRURLSessionStaticResponseHandler = handler;
}

#pragma mark - Overridden methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return VCRURLSessionStaticResponseHandler && VCRURLSessionStaticResponseHandler(request);
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
    if (!VCRURLSessionStaticResponseHandler) {
        return;
    }

    VCRURLSessionResponse *response = VCRURLSessionStaticResponseHandler(self.request);

    if (response.error) {
        [self.client URLProtocol:self didFailWithError:response.error];
        return;
    }

    if (response.httpResponse) {
        [self.client URLProtocol:self didReceiveResponse:response.httpResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    }

    if (response.data) {
        [self.client URLProtocol:self didLoadData:response.data];
    }

    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
}

@end

#endif
