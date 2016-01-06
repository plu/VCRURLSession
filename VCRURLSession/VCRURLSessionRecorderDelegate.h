//
//  VCRURLSessionRecorderDelegate.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCRURLSessionRecorderDelegate <NSObject>

@required
- (void)recordRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error;

@end
