//
//  NSURLRequest+VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "NSURLRequest+VCRURLSession.h"

static NSString *VCRURLSessionRequestHeadersKey = @"headers";
static NSString *VCRURLSessionRequestMethodKey = @"method";
static NSString *VCRURLSessionRequestURLKey = @"url";

@implementation NSURLRequest (VCRURLSession)

- (NSDictionary *)VCRURLSession_dictionaryValue
{
    return @{
        VCRURLSessionRequestHeadersKey : self.allHTTPHeaderFields ?: @{},
        VCRURLSessionRequestMethodKey : self.HTTPMethod ?: @"",
        VCRURLSessionRequestURLKey : self.URL.absoluteString ?: @"",
    };
}

@end
