//
//  VCRURLSessionRecord.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCRURLSessionRecord : NSObject

@property (nonatomic, readonly) NSUInteger requestID;
@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) NSHTTPURLResponse *_Nullable response;
@property (nonatomic, readonly) NSData *_Nullable data;
@property (nonatomic, readonly) NSError *_Nullable error;
@property (nonatomic, readonly) NSDictionary *dictionaryValue;

@property (nonatomic) NSTimeInterval responseTime;
@property (nonatomic) BOOL played;

- (instancetype)initWithDictionary:(NSDictionary *)recordDictionary;
- (instancetype)initWithRequestID:(NSUInteger)requestID
                          request:(NSURLRequest *)request
                     responseTime:(NSTimeInterval)responseTime
                         response:(NSHTTPURLResponse *_Nullable)response
                             data:(NSData *_Nullable)data
                            error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
