//
//  VCRURLSessionCassette.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#if DEBUG

#import "NSData+VCRURLSession.h"
#import "VCRURLSessionCassette.h"
#import "VCRURLSessionRecord.h"
#import "VCRURLSessionResponse.h"

static NSString *VCRURLSessionCassetteRecordingTimeKey = @"recordingTime";
static NSString *VCRURLSessionCassetteRecordsKey = @"records";
static NSString *VCRURLSessionCassetteUserInfoKey = @"userInfo";

@interface VCRURLSessionCassette ()

@property (nonatomic) NSUInteger requestID;
@property (nonatomic) NSMutableArray<VCRURLSessionRecord *> *data;
@property (nonatomic, readonly) NSArray<NSDictionary *> *dictionaryValues;

@end

@implementation VCRURLSessionCassette

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
        _recordingDate = [NSDate date];
        _replaySpeed = 1.0f;
        _requestID = 0;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data
{
    self = [self init];
    if (self) {
        NSDictionary *cassette = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *records = cassette[VCRURLSessionCassetteRecordsKey];
        for (NSDictionary *recordDictionary in records) {
            [self.data addObject:[[VCRURLSessionRecord alloc] initWithDictionary:recordDictionary]];
        }
        self.userInfo = cassette[VCRURLSessionCassetteUserInfoKey];

        NSTimeInterval recordingTime = [cassette[VCRURLSessionCassetteRecordingTimeKey] doubleValue];
        if (recordingTime > 0.0f) {
            self.recordingDate = [NSDate dateWithTimeIntervalSince1970:recordingTime];
        }
    }
    return self;
}

- (instancetype)initWithCompressedContentsOfFile:(NSString *)path
{
    return [self initWithData:[[[NSData alloc] initWithContentsOfFile:path] VCRURLSession_gunzippedData]];
}

- (instancetype)initWithContentsOfFile:(NSString *)path
{
    return [self initWithData:[[NSData alloc] initWithContentsOfFile:path]];
}

- (NSUInteger)numberOfRecords
{
    return self.data.count;
}

- (NSUInteger)numberOfPlayedRecords
{
    NSUInteger playedRecords = 0;
    for (VCRURLSessionRecord *record in self.data) {
        if (record.played) {
            playedRecords++;
        }
    }
    return playedRecords;
}

- (BOOL)writeToFile:(NSString *)path
{
    return [[self dataValue] writeToFile:path atomically:YES];
}

- (BOOL)writeCompressedToFile:(NSString *)path
{
    return [[[self dataValue] VCRURLSession_gzippedData] writeToFile:path atomically:YES];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p records:%zd>", NSStringFromClass([self class]), self, self.numberOfRecords];
}

#pragma mark - Private

- (NSData *)dataValue
{
    return [NSJSONSerialization dataWithJSONObject:self.dictionaryValues options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSDictionary *)dictionaryValues
{
    NSMutableArray *records = [NSMutableArray array];
    @synchronized (self) {
        for (VCRURLSessionRecord *record in self.data) {
            [records addObject:record.dictionaryValue];
        }
    }
    return @{
        VCRURLSessionCassetteRecordingTimeKey : @(self.recordingDate.timeIntervalSince1970),
        VCRURLSessionCassetteRecordsKey : records.copy,
        VCRURLSessionCassetteUserInfoKey : self.userInfo ?: @{},
    };
}

#pragma mark - VCRURLSessionRecorderDelegate

- (BOOL)recordRequest:(NSURLRequest *)request
         responseTime:(NSTimeInterval)responseTime
             response:(NSHTTPURLResponse *)response
                 data:(NSData *)data
                error:(NSError *)error
{
    BOOL recordRequest = YES;
    if (self.recordFilter && !self.recordFilter(request)) {
        recordRequest = NO;
    }

    if (recordRequest) {
        @synchronized (self) {
            VCRURLSessionRecord *record =
                [[VCRURLSessionRecord alloc] initWithRequestID:self.requestID request:request responseTime:responseTime response:response data:data error:error];
            [self.data addObject:record];
            self.requestID += 1;
        }
    }

    return recordRequest;
}

#pragma mark - VCRURLSessionPlayerDelegate

- (VCRURLSessionRecord *_Nullable)recordForRequest:(NSURLRequest *)request
{
    VCRURLSessionRecord *matchingRecord;
    for (VCRURLSessionRecord *record in self.data) {
        if (record.played) {
            continue;
        }

        BOOL hasMatchingMethod = [record.request.HTTPMethod isEqualToString:request.HTTPMethod];
        BOOL hasMatchingURL = [record.request.URL isEqual:request.URL];
        if (hasMatchingMethod && hasMatchingURL) {
            matchingRecord = record;
            break;
        }
    }
    matchingRecord.responseTime = (1.0f / self.replaySpeed) * matchingRecord.responseTime;
    return matchingRecord;
}

@end

#endif
