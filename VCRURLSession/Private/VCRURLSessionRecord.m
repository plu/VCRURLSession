//
//  VCRURLSessionRecord.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "NSError+VCRURLSession.h"
#import "NSURLResponse+VCRURLSession.h"
#import "NSURLRequest+VCRURLSession.h"
#import "VCRURLSessionRecord.h"

static NSString *VCRURLSessionRecordRequestIDKey = @"requestID";
static NSString *VCRURLSessionRecordRequestKey = @"request";
static NSString *VCRURLSessionRecordResponseKey = @"response";
static NSString *VCRURLSessionRecordResponseTimeKey = @"responseTime";
static NSString *VCRURLSessionRecordErrorKey = @"error";

@interface VCRURLSessionRecord ()

@property (nonatomic) NSUInteger requestID;
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
        _requestID = [recordDictionary[VCRURLSessionRecordRequestIDKey] unsignedIntegerValue];
        _request = [[NSURLRequest alloc] VCRURLSession_initWithDictionary:recordDictionary[VCRURLSessionRecordRequestKey]];
        _responseTime = [recordDictionary[VCRURLSessionRecordResponseTimeKey] doubleValue];

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

- (instancetype)initWithRequestID:(NSUInteger)requestID
                          request:(NSURLRequest *)request
                     responseTime:(NSTimeInterval)responseTime
                         response:(NSHTTPURLResponse *_Nullable)response
                             data:(NSData *_Nullable)data
                            error:(NSError *_Nullable)error
{
    self = [super init];
    if (self) {
        _requestID = requestID;
        _request = request;
        _responseTime = responseTime;
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
        VCRURLSessionRecordRequestIDKey : @(self.requestID),
        VCRURLSessionRecordRequestKey : self.request.VCRURLSession_dictionaryValue ?: @{},
        VCRURLSessionRecordResponseKey : [self.response VCRURLSession_dictionaryValueWithData:self.data] ?: @{},
        VCRURLSessionRecordResponseTimeKey : @(self.responseTime),
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p requestID:%zd method:%@ url:%@ statusCode:%zd>", NSStringFromClass([self class]), self, self.requestID,
                                      self.request.HTTPMethod, self.request.URL.absoluteString, self.response.statusCode];
}

@end
