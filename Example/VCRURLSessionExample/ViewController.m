//
//  ViewController.m
//  VCRURLSessionExample
//
//  Created by Plunien, Johannes on 14/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

#import "ViewController.h"
#import <VCRURLSession/VCRURLSessionController.h>

@interface ViewController ()

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSString *path;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.path = [self pathToCassetteWithName:@"github.com"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
        NSLog(@"Recording new cassette to path: %@", self.path);
        [self record];
    }
    else {
        NSLog(@"Replaying cassette from path: %@", self.path);
        [self replay];
    }
}

- (void)record
{
    // Set up `protocolClasses` and return new session
    self.session = [VCRURLSessionController prepareURLSession:[NSURLSession sharedSession]];

    // Create new empty cassette to record HTTP requests on
    VCRURLSessionCassette *cassette = [[VCRURLSessionCassette alloc] init];

    // Start recording HTTP requests
    [VCRURLSessionController startRecordingOnCassette:cassette];

    // Make some HTTP request
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"https://www.github.com"]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     [VCRURLSessionController stopRecording];
                     [cassette writeToFile:self.path];
                 }] resume];
}

- (void)replay
{
    // Set up `protocolClasses` and return new session
    self.session = [VCRURLSessionController prepareURLSession:[NSURLSession sharedSession]];

    // Load cassette
    VCRURLSessionCassette *cassette = [[VCRURLSessionCassette alloc] initWithContentsOfFile:self.path];
    [VCRURLSessionController startReplayingWithCassette:cassette mode:VCRURLSessionReplayModeStrict];

    // Make some HTTP request
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"https://www.github.com"]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                     NSLog(@"%zd - %@", httpResponse.statusCode, httpResponse.URL);
                 }] resume];
}

- (NSString *)pathToCassetteWithName:(NSString *)name
{
    NSString *path = [NSProcessInfo processInfo].environment[@"CASSETTES_PATH"];
    path = [path stringByAppendingPathComponent:name];
    path = [path stringByAppendingPathExtension:@"json"];
    return path;
}

@end
