//
//  VCRURLSessionResponse.h
//  VCRURLSession
//
//  Created by Johannes Plunien on 10/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Static HTTP response container.
 */
@interface VCRURLSessionResponse : NSObject

/**
 *  The `NSHTTPURLResponse` instance.
 */
@property (nonatomic, readonly) NSHTTPURLResponse *httpResponse;

/**
 *  The `NSData` instance that belongs to the response (optional).
 */
@property (nonatomic, readonly) NSData *_Nullable data;

/**
 *  The `NSError` instance that belongs to the response (optional).
 */
@property (nonatomic, readonly) NSError *error;

/**
 *  Convenience initializer to create a new instance.
 *
 *  @param url          URL of the request
 *  @param statusCode   HTTP status code
 *  @param headerFields HTTP header fields (optional)
 *  @param data         HTTP body (optional)
 *  @param error        Some `NSError` instance (optional)
 *
 *  @return `VCRURLSessionResponse` instance.
 */
+ (instancetype)responseWithURL:(NSURL *)url
                     statusCode:(NSInteger)statusCode
                   headerFields:(NSDictionary<NSString *, NSString *> *_Nullable)headerFields
                           data:(NSData *_Nullable)data
                          error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END

#endif
