# Description

`VCRURLSession` let's you record your test suite's HTTP requests and responses.
You can replay them during future test runs for fast, deterministic, accurate tests.

The recording and replaying of requests is implemented as a `NSURLProtocol` subclass.
To use url protocols, they must be set on the `NSURLSession`'s configuration object.

# Usage

```objc
// This sets up `protocolClasses` and returns a new session
NSURLSession *session = [VCRURLSession prepareURLSession:[NSURLSession sharedSession]];

// Create a new empty cassette to record HTTP requests on
VCRURLSessionCassette *cassette = [[VCRURLSessionCassette alloc] init];

// Start recording HTTP requests
[VCRURLSession startRecordingOnCassette:cassette];

// Make some HTTP requests
[session dataTaskWithURL:[NSURL URLWithString:@"https://www.github.com"]];

// After the response has arrived
[VCRURLSession stopRecording];
[cassette writeToFile:@"/tmp/cassette.json"];
```
