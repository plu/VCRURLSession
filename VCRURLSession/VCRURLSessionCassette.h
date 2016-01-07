//
//  VCRURLSessionCassette.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionRecorderDelegate.h"
#import <Foundation/Foundation.h>

@class VCRURLSessionRecord;

NS_ASSUME_NONNULL_BEGIN

@interface VCRURLSessionCassette : NSObject <VCRURLSessionRecorderDelegate>

@property (nonatomic, readonly) NSArray<VCRURLSessionRecord *> *records;

- (BOOL)writeToFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
