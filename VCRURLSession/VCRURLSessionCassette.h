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

/**
 *  Stores/retrieves recorded HTTP requests and responses.
 */
@interface VCRURLSessionCassette : NSObject <VCRURLSessionPlayerDelegate, VCRURLSessionRecorderDelegate>

/**
 *  Decide which requests to record.
 */
@property (nonatomic, copy) BOOL (^recordFilter)(NSURLRequest *request);

/**
 *  Number of records.
 */
@property (nonatomic, readonly) NSUInteger numberOfRecords;

/**
 *  `NSDate` instance representing the date when the recording of this cassette started. It will also
 *  be serialized/deserialized when writing/loading the cassette.
 */
@property (nonatomic, copy) NSDate *recordingDate;

/**
 *  Some `NSDictionary` instance, will also be serialized/deserialized when writing/loading the cassette.
 */
@property (nonatomic) NSDictionary *_Nullable userInfo;

/**
 *  Speed in which the records should be replayed with. Defaults to 1.0
 *  Example: If `responseTime` of a record was 500ms and `replaySpeed` is set to 2.0, the response will
 *  be returned after 250ms when replaying.
 */
@property (nonatomic) double replaySpeed;

/**
 *  Load cassette with JSON content from given path.
 *
 *  @param path full path to the cassette file.
 *
 *  @return `VCRURLSessionCassette` instance.
 */
- (instancetype)initWithContentsOfFile:(NSString *)path;

/**
 *  Load cassette with gzipped JSON content from given path.
 *
 *  @param path full path to the cassette file.
 *
 *  @return `VCRURLSessionCassette` instance.
 */
- (instancetype)initWithCompressedContentsOfFile:(NSString *)path;

/**
 *  Store cassette in JSON format to given path.
 *
 *  @param path full path to the cassette file.
 *
 *  @return true/false
 */
- (BOOL)writeToFile:(NSString *)path;

/**
 *  Store cassette in gzipped JSON format to given path.
 *
 *  @param path full path to the cassette file.
 *
 *  @return true/false
 */
- (BOOL)writeCompressedToFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
