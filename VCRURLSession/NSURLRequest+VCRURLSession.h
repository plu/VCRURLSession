//
//  NSURLRequest+VCRURLSession.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (VCRURLSession)

@property (nonatomic, readonly) NSDictionary *VCRURLSession_dictionaryValue;

- (instancetype)VCRURLSession_initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

#endif
