//
//  VCRURLSessionRecorder.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSession.h"
#import "VCRURLSessionRecorder.h"
#import "VCRURLSessionRecorderDelegate.h"

static NSString *VCRURLSessionRecorderTaskKey = @"VCRURLSessionRecorderTaskKey";
static id<VCRURLSessionRecorderDelegate> VCRURLSessionRecorderSharedDelegate = nil;

@interface VCRURLSessionRecorder ()

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
    self.session = [NSURLSession sessionWithConfiguration:configuration];

    NSURLSessionTask *task =
        [self.session dataTaskWithRequest:self.request
                        completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
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

                            [VCRURLSessionRecorderSharedDelegate recordRequest:self.request response:(NSHTTPURLResponse *)response data:data error:error];
                        }];

    [[self class] setProperty:task forKey:VCRURLSessionRecorderTaskKey inRequest:self.request.mutableCopy];
    [task resume];
}

- (void)stopLoading
{
    NSURLSessionTask *task = [[self class] propertyForKey:VCRURLSessionRecorderTaskKey inRequest:self.request];
    [task cancel];
}

@end
