//
//  VCRURLSessionRecorderDelegate.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VCRURLSessionRecorderDelegate <NSObject>

@required
- (void)recordRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *_Nullable)response data:(NSData *_Nullable)data error:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
