//
//  VCRURLSessionResponse.m
//  VCRURLSession
//
//  Created by Johannes Plunien on 10/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionResponse.h"

@interface VCRURLSessionResponse ()

@property (nonatomic) NSHTTPURLResponse *httpResponse;
@property (nonatomic) NSData *data;
@property (nonatomic) NSError *error;

@end

@implementation VCRURLSessionResponse

+ (instancetype)responseWithURL:(NSURL *)url
                     statusCode:(NSInteger)statusCode
                   headerFields:(NSDictionary<NSString *, NSString *> *_Nullable)headerFields
                           data:(NSData *_Nullable)data
                          error:(NSError *_Nullable)error
{
    VCRURLSessionResponse *instance = [[VCRURLSessionResponse alloc] init];
    instance.data = data;
    instance.error = error;
    instance.httpResponse = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:statusCode HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
    return instance;
}

@end
