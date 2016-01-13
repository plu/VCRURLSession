//
//  NSData+VCRURLSession.m
//  VCRURLSession
//
//  Created by Plunien, Johannes on 11/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//  Copyright 2008 ManicPanda.com. All rights reserved.
//

#import "NSData+VCRURLSession.h"
#import <zlib.h>

@implementation NSData (VCRURLSession)

- (NSData *)VCRURLSession_gunzippedData
{
    if (self.length == 0) {
        return self;
    }

    unsigned fullLength = (uInt)self.length;
    unsigned halfLength = (uInt)self.length / 2;

    NSMutableData *decompressed = [NSMutableData dataWithLength:fullLength + halfLength];
    BOOL done = NO;
    int status;

    z_stream strm;
    strm.next_in = (Bytef *)self.bytes;
    strm.avail_in = (uint)self.length;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;

    if (inflateInit2(&strm, (15 + 32)) != Z_OK)
        return nil;
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= decompressed.length)
            [decompressed increaseLengthBy:halfLength];
        strm.next_out = decompressed.mutableBytes + strm.total_out;
        strm.avail_out = (uInt)(decompressed.length - strm.total_out);

        // Inflate another chunk.
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END)
            done = YES;
        else if (status != Z_OK)
            break;
    }
    if (inflateEnd(&strm) != Z_OK)
        return nil;

    // Set real length.
    if (done) {
        [decompressed setLength:strm.total_out];
        return [NSData dataWithData:decompressed];
    }

    return nil;
}

- (NSData *)VCRURLSession_gzippedData
{
    if (self.length == 0)
        return self;

    z_stream strm;

    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    strm.opaque = Z_NULL;
    strm.total_out = 0;
    strm.next_in = (Bytef *)[self bytes];
    strm.avail_in = (uint)self.length;

    // Compresssion Levels:
    //   Z_NO_COMPRESSION
    //   Z_BEST_SPEED
    //   Z_BEST_COMPRESSION
    //   Z_DEFAULT_COMPRESSION

    if (deflateInit2(&strm, Z_BEST_COMPRESSION, Z_DEFLATED, (15 + 16), 8, Z_DEFAULT_STRATEGY) != Z_OK)
        return nil;

    // 16K chunks for expansion
    NSMutableData *compressed = [NSMutableData dataWithLength:16384];

    do {

        if (strm.total_out >= compressed.length)
            [compressed increaseLengthBy:16384];

        strm.next_out = compressed.mutableBytes + strm.total_out;
        strm.avail_out = (uInt)(compressed.length - strm.total_out);

        deflate(&strm, Z_FINISH);

    } while (strm.avail_out == 0);

    deflateEnd(&strm);

    [compressed setLength:strm.total_out];
    return [NSData dataWithData:compressed];
}

@end
