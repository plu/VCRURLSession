//
//  VCRURLSessionRecorder.h
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCRURLSessionRecorderDelegate;

@interface VCRURLSessionRecorder : NSURLProtocol

+ (BOOL)isRecording;
+ (void)startRecordingWithDelegate:(id<VCRURLSessionRecorderDelegate>)delegate;
+ (void)stopRecording;

@end
