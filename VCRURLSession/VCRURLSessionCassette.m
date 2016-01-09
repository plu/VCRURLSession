//
//  VCRURLSessionCassette.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionCassette.h"
#import "VCRURLSessionRecord.h"

static NSString *VCRURLSessionCassetteRecordsKey = @"records";

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

- (instancetype)initWithContentsOfFile:(NSString *)path
{
    self = [self init];
    if (self) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSDictionary *cassette = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *records = cassette[VCRURLSessionCassetteRecordsKey];
        for (NSDictionary *recordDictionary in records) {
            [self.data addObject:[[VCRURLSessionRecord alloc] initWithDictionary:recordDictionary]];
        }
    }
    return self;
}

- (NSArray<VCRURLSessionRecord *> *)records
{
    return self.data.copy;
}

- (BOOL)writeToFile:(NSString *)path
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionaryValues options:NSJSONWritingPrettyPrinted error:nil];
    return [data writeToFile:path atomically:YES];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%p records:%zd>", NSStringFromClass([self class]), self, self.records.count];
}

#pragma mark - Private

- (NSDictionary *)dictionaryValues
{
    NSMutableArray *records = [NSMutableArray array];
    for (VCRURLSessionRecord *record in self.data) {
        [records addObject:record.dictionaryValue];
    }
    return @{VCRURLSessionCassetteRecordsKey: records.copy};
}

#pragma mark - VCRURLSessionRecorderDelegate

- (void)recordRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    VCRURLSessionRecord *record = [[VCRURLSessionRecord alloc] initWithRequest:request response:response data:data error:error];
    [self.data addObject:record];
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
    return matchingRecord;
}

@end
