//
//  VCRURLSessionRecord.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "NSError+VCRURLSession.h"
#import "NSHTTPURLResponse+VCRURLSession.h"
#import "NSURLRequest+VCRURLSession.h"
#import "VCRURLSessionRecord.h"

static NSString *VCRURLSessionRecordRequestKey = @"request";
static NSString *VCRURLSessionRecordResponseKey = @"response";
static NSString *VCRURLSessionRecordErrorKey = @"error";

@interface VCRURLSessionRecord ()

@property (nonatomic) NSURLRequest *request;
@property (nonatomic) NSHTTPURLResponse *response;
@property (nonatomic) NSData *data;
@property (nonatomic) NSError *error;

@end

@implementation VCRURLSessionRecord

- (instancetype)initWithDictionary:(NSDictionary *)recordDictionary
{
    self = [super init];
    if (self) {
        _request = [[NSURLRequest alloc] VCRURLSession_initWithDictionary:recordDictionary[VCRURLSessionRecordRequestKey]];

        NSDictionary *responseDictionary = recordDictionary[VCRURLSessionRecordResponseKey];
        if (responseDictionary.count) {
            _response = [[NSHTTPURLResponse alloc] VCRURLSession_initWithDictionary:responseDictionary];
            _data = [_response VCRURLSession_decodedDataFromDictionary:responseDictionary];
        }

        NSDictionary *errorDictionary = recordDictionary[VCRURLSessionRecordErrorKey];
        if (errorDictionary.count) {
            _error = [[NSError alloc] VCRURLSession_initWithDictionary:errorDictionary];
        }
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    self = [super init];
    if (self) {
        _request = request;
        _response = response;
        _data = data;
        _error = error;
    }
    return self;
}

- (NSDictionary *)dictionaryValue
{
    return @{
        VCRURLSessionRecordErrorKey : self.error.VCRURLSession_dictionaryValue ?: @{},
        VCRURLSessionRecordRequestKey : self.request.VCRURLSession_dictionaryValue ?: @{},
        VCRURLSessionRecordResponseKey : [self.response VCRURLSession_dictionaryValueWithData:self.data] ?: @{},
    };
}

- (NSString *)description
{
    return [NSString
        stringWithFormat:@"<%@:%p url:%@ statusCode:%zd>", NSStringFromClass([self class]), self, self.request.URL.absoluteString, self.response.statusCode];
}

@end
