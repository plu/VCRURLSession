//
//  VCRURLSessionPlayerDelegate.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VCRURLSessionRecord;

NS_ASSUME_NONNULL_BEGIN

@protocol VCRURLSessionPlayerDelegate <NSObject>

@required
- (VCRURLSessionRecord *_Nullable)recordForRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
