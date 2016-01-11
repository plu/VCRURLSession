//
//  VCRURLSessionCassette.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionPlayerDelegate.h"
#import "VCRURLSessionRecorderDelegate.h"
#import <Foundation/Foundation.h>

@class VCRURLSessionRecord;
@class VCRURLSessionResponse;

NS_ASSUME_NONNULL_BEGIN

@interface VCRURLSessionCassette : NSObject <VCRURLSessionPlayerDelegate, VCRURLSessionRecorderDelegate>

@property (nonatomic, copy) BOOL (^recordFilter)(NSURLRequest *request);
@property (nonatomic, readonly) NSArray<VCRURLSessionRecord *> *records;
@property (nonatomic) NSDictionary *_Nullable userInfo;

- (instancetype)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithCompressedContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)path;
- (BOOL)writeCompressedToFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
