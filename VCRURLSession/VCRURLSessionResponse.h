//
//  VCRURLSessionResponse.h
//  VCRURLSession
//
//  Created by Johannes Plunien on 10/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCRURLSessionResponse : NSObject

@property (nonatomic, readonly) NSHTTPURLResponse *httpResponse;
@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) NSError *error;

+ (instancetype)responseWithURL:(NSURL *)url
                     statusCode:(NSInteger)statusCode
                   headerFields:(NSDictionary<NSString *, NSString *> *_Nullable)headerFields
                           data:(NSData *_Nullable)data
                          error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
