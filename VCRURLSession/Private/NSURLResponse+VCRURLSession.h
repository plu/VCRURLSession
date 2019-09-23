//
//  NSURLResponse+VCRURLSession.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLResponse (VCRURLSession)

- (instancetype)VCRURLSession_initWithDictionary:(NSDictionary *)dictionary;
- (NSData *)VCRURLSession_decodedDataFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)VCRURLSession_dictionaryValueWithData:(NSData *_Nullable)data;

@end

NS_ASSUME_NONNULL_END
