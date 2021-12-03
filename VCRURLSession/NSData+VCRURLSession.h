//
//  NSData+VCRURLSession.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 11/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import <Foundation/Foundation.h>

@interface NSData (VCRURLSession)

- (NSData *)VCRURLSession_gunzippedData;
- (NSData *)VCRURLSession_gzippedData;

@end

#endif
