//
//  NSURLResponse+VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "NSURLResponse+VCRURLSession.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString *VCRURLSessionResponseBodyKey = @"body";
static NSString *VCRURLSessionResponseHeadersKey = @"headers";
static NSString *VCRURLSessionResponseStatusCodeKey = @"statusCode";
static NSString *VCRURLSessionResponseURLKey = @"url";

@implementation NSURLResponse (VCRURLSession)

- (instancetype)VCRURLSession_initWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *headers = dictionary[VCRURLSessionResponseHeadersKey];
    NSInteger statusCode = [dictionary[VCRURLSessionResponseStatusCodeKey] integerValue];
    NSURL *url = [[NSURL alloc] initWithString:dictionary[VCRURLSessionResponseURLKey]];
    return [[NSHTTPURLResponse alloc] initWithURL:url statusCode:statusCode HTTPVersion:@"HTTP/1.1" headerFields:headers];
}

- (NSData *)VCRURLSession_decodedDataFromDictionary:(NSDictionary *)dictionary
{
    id body = dictionary[VCRURLSessionResponseBodyKey];
    if ([self VCRURLSession_isJSONResponse] && [NSJSONSerialization isValidJSONObject:body]) {
        return [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    }
    if ([body isKindOfClass:[NSString class]] && [self VCRURLSession_isTextResponse]) {
        return [body dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [[NSData alloc] initWithBase64EncodedString:body options:0];
}

- (NSDictionary *)VCRURLSession_dictionaryValueWithData:(NSData *)data
{
    NSDictionary *allHeaderFields = @{};
    NSInteger statusCode = 200;

    if ([self isKindOfClass:NSHTTPURLResponse.class]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)self;
        allHeaderFields = httpResponse.allHeaderFields ?: @{};
        statusCode = httpResponse.statusCode;
    }

    return @{
        VCRURLSessionResponseBodyKey : [self VCRURLSession_bodyValue:data],
        VCRURLSessionResponseHeadersKey : allHeaderFields,
        VCRURLSessionResponseStatusCodeKey : @(statusCode),
        VCRURLSessionResponseURLKey : self.URL.absoluteString,
    };
}

#pragma mark - Private

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
    return isJSONResponse || [type containsString:@"json"];
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
    return isTextResponse || [type containsString:@"json"];
}

@end
