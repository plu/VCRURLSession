//
//  NSError+VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "NSError+VCRURLSession.h"

static NSString *VCRURLSessionErrorCodeKey = @"code";
static NSString *VCRURLSessionErrorDomainKey = @"domain";
static NSString *VCRURLSessionErrorUserInfoKey = @"userInfo";

@implementation NSError (VCRURLSession)

- (instancetype)VCRURLSession_initWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *userInfo;
    if (dictionary[VCRURLSessionErrorUserInfoKey]) {
        NSData *userInfoData = [[NSData alloc] initWithBase64EncodedString:dictionary[VCRURLSessionErrorUserInfoKey] options:0];
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
    }
    return [NSError errorWithDomain:dictionary[VCRURLSessionErrorDomainKey] code:[dictionary[VCRURLSessionErrorCodeKey] integerValue] userInfo:userInfo];
}

- (NSDictionary *)VCRURLSession_dictionaryValue
{
    return @{
        VCRURLSessionErrorCodeKey : @(self.code),
        VCRURLSessionErrorDomainKey : self.domain,
        VCRURLSessionErrorUserInfoKey : [[NSKeyedArchiver archivedDataWithRootObject:self.userInfo] base64EncodedStringWithOptions:0],
    };
}

@end
