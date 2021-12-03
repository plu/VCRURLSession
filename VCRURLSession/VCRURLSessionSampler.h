//
//  VCRURLSessionSampler.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 11/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import <Foundation/Foundation.h>

@class VCRURLSessionResponse;

NS_ASSUME_NONNULL_BEGIN

@interface VCRURLSessionSampler : NSURLProtocol

+ (void)setStaticResponseHandler:(VCRURLSessionResponse *_Nullable (^)(NSURLRequest *request))handler;

@end

NS_ASSUME_NONNULL_END

#endif
