//
//  VCRURLSessionTestsHelper.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "VCRURLSessionTestsHelper.h"

#ifndef CASSETTES_ROOT
#define CASSETTES_ROOT ""
#endif

@implementation VCRURLSessionTestsHelper

+ (NSString *)pathToCassetteWithName:(NSString *)name
{
    NSURL *baseURL = [NSURL URLWithString:@(CASSETTES_ROOT)];
    return [[baseURL URLByAppendingPathComponent:name] path];
}

@end
