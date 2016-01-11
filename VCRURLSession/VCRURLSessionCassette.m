//
//  VCRURLSessionCassette.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "NSData+VCRURLSession.h"
#import "VCRURLSessionCassette.h"
#import "VCRURLSessionRecord.h"
#import "VCRURLSessionResponse.h"

static NSString *VCRURLSessionCassetteRecordsKey = @"records";
static NSString *VCRURLSessionCassetteUserInfoKey = @"userInfo";

@interface VCRURLSessionCassette ()

@property (nonatomic) NSMutableArray<VCRURLSessionRecord *> *data;
@property (nonatomic, readonly) NSArray<NSDictionary *> *dictionaryValues;

@end

@implementation VCRURLSessionCassette

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableArray array];
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

- (NSArray<VCRURLSessionRecord *> *)records
{
    return self.data.copy;
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
    return [NSString stringWithFormat:@"<%@:%p records:%zd>", NSStringFromClass([self class]), self, self.records.count];
}

#pragma mark - Private

- (NSData *)dataValue
{
    return [NSJSONSerialization dataWithJSONObject:self.dictionaryValues options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSDictionary *)dictionaryValues
{
    NSMutableArray *records = [NSMutableArray array];
    for (VCRURLSessionRecord *record in self.data) {
        [records addObject:record.dictionaryValue];
    }
    return @{
        VCRURLSessionCassetteRecordsKey : records.copy,
        VCRURLSessionCassetteUserInfoKey : self.userInfo ?: @{},
    };
}

#pragma mark - VCRURLSessionRecorderDelegate

- (void)recordRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    BOOL recordRequest = YES;
    if (self.recordFilter && !self.recordFilter(request)) {
        recordRequest = NO;
    }

    if (recordRequest) {
        VCRURLSessionRecord *record = [[VCRURLSessionRecord alloc] initWithRequest:request response:response data:data error:error];
        [self.data addObject:record];
    }
}

#pragma mark - VCRURLSessionPlayerDelegate

- (VCRURLSessionRecord *_Nullable)recordForRequest:(NSURLRequest *)request
{
    if (self.replayFilter) {
        VCRURLSessionResponse *response = self.replayFilter(request);
        if (response) {
            return [[VCRURLSessionRecord alloc] initWithRequest:request response:response.httpResponse data:response.data error:response.error];
        }
    }

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
    return matchingRecord;
}

@end
