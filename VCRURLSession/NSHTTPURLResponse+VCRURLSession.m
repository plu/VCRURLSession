//
//  NSHTTPURLResponse+VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "NSHTTPURLResponse+VCRURLSession.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString *VCRURLSessionResponseBodyKey = @"body";
static NSString *VCRURLSessionResponseHeadersKey = @"headers";
static NSString *VCRURLSessionResponseStatusCodeKey = @"statusCode";

@implementation NSHTTPURLResponse (VCRURLSession)

- (NSDictionary *)VCRURLSession_dictionaryValueWithData:(NSData *)data
{
    return @{
        VCRURLSessionResponseBodyKey : [self VCRURLSession_bodyValue:data],
        VCRURLSessionResponseHeadersKey : self.allHeaderFields,
        VCRURLSessionResponseStatusCodeKey : @(self.statusCode),
    };
}

- (id)VCRURLSession_bodyValue:(NSData *)data
{
    if (data.length && [self VCRURLSession_isJSONResponse]) {
        // Try to decode JSON here so it will be pretty printed later on
        NSError *error;
        id bodyValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error && bodyValue) {
            return bodyValue;
        }
    }

    if ([self VCRURLSession_isTextResponse]) {
        NSString *bodyValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (bodyValue) {
            return bodyValue;
        }
    }

    return [data base64EncodedStringWithOptions:0];
}

- (BOOL)VCRURLSession_isJSONResponse
{
    NSString *type = self.MIMEType ?: @"";
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)type, NULL);
    BOOL isJSONResponse = UTTypeConformsTo(uti, kUTTypeJSON);
    if (uti) {
        CFRelease(uti);
    }
    return isJSONResponse;
}

- (BOOL)VCRURLSession_isTextResponse
{
    NSString *type = self.MIMEType ?: @"";
    if ([@[ @"application/x-www-form-urlencoded" ] containsObject:type]) {
        return YES;
    }
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)type, NULL);
    BOOL isTextResponse = UTTypeConformsTo(uti, kUTTypeText);
    if (uti) {
        CFRelease(uti);
    }
    return isTextResponse;
}

@end
