//
//  NSError+VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import "NSError+VCRURLSession.h"

static NSString *VCRURLSessionErrorCodeKey = @"code";
static NSString *VCRURLSessionErrorDomainKey = @"domain";

@implementation NSError (VCRURLSession)

- (instancetype)VCRURLSession_initWithDictionary:(NSDictionary *)dictionary
{
    return [NSError errorWithDomain:dictionary[VCRURLSessionErrorDomainKey] code:[dictionary[VCRURLSessionErrorCodeKey] integerValue] userInfo:nil];
}

- (NSDictionary *)VCRURLSession_dictionaryValue
{
    return @{
        VCRURLSessionErrorCodeKey : @(self.code),
        VCRURLSessionErrorDomainKey : self.domain,
    };
}

@end

#endif
