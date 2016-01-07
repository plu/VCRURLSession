//
//  VCRURLSessionCassette.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionCassette.h"
#import "VCRURLSessionRecord.h"

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

- (NSArray<VCRURLSessionRecord *> *)records
{
    return self.data.copy;
}

- (BOOL)writeToFile:(NSString *)path
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dictionaryValues options:NSJSONWritingPrettyPrinted error:nil];
    return [data writeToFile:path atomically:YES];
}

#pragma mark - Private

- (NSArray<NSDictionary *> *)dictionaryValues
{
    NSMutableArray *dictionaryValues = [NSMutableArray array];
    for (VCRURLSessionRecord *record in self.data) {
        [dictionaryValues addObject:record.dictionaryValue];
    }
    return dictionaryValues.copy;
}

#pragma mark - VCRURLSessionRecorderDelegate

- (void)recordRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    VCRURLSessionRecord *record = [[VCRURLSessionRecord alloc] initWithRequest:request response:response data:data error:error];
    [self.data addObject:record];
}

@end
