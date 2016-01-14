# Description

`VCRURLSession` let's you record your test suite's HTTP requests and responses.
You can replay them during future test runs for fast, deterministic, accurate tests.

To use `VCRURLSession` you must configure your `NSURLSession` instances:

```objc
NSURLSession *session = [VCRURLSession prepareURLSession:[NSURLSession sharedSession]];
```

There is no swizzling involved!

# Usage

## Recording

```objc
- (void)record
{
    // Set up `protocolClasses` and return new session
    self.session = [VCRURLSession prepareURLSession:[NSURLSession sharedSession]];

    // Create new empty cassette to record HTTP requests on
    VCRURLSessionCassette *cassette = [[VCRURLSessionCassette alloc] init];

    // Start recording HTTP requests
    [VCRURLSession startRecordingOnCassette:cassette];

    // Make some HTTP request
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"https://www.github.com"]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     [VCRURLSession stopRecording];
                     [cassette writeToFile:self.path];
                 }] resume];
}
```

## Replaying

```objc
- (void)replay
{
    // Set up `protocolClasses` and return new session
    self.session = [VCRURLSession prepareURLSession:[NSURLSession sharedSession]];

    // Load cassette
    VCRURLSessionCassette *cassette = [[VCRURLSessionCassette alloc] initWithContentsOfFile:self.path];
    [VCRURLSession startReplayingWithCassette:cassette mode:VCRURLSessionReplayModeStrict];

    // Make some HTTP request
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"https://www.github.com"]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                     NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                     NSLog(@"%zd - %@", httpResponse.statusCode, httpResponse.URL);
                 }] resume];
}
```

# Features

* **Replaying consumes responses**

	Let's assume during recording there are several requests made to the same resource (`GET /users`).
When replaying them, it will consume them in the same order they were recorded.

	Example:

	```
	GET /users
	200 OK
	[]

	POST /users?name=John
	201 Created
	{"id": 1, "name": "John"}

	GET /users
	200 OK
	[{"id": 1, "name": "John"}]

	DELETE /users/1
	204 No Content

	GET /users
	200 OK
	[]
	```
* **Responses can be stored in gzipped format**

	Example:
	
	```objc
    VCRURLSessionCassette *cassette = [[VCRURLSessionCassette alloc] init];
    [cassette writeCompressedToFile:@"/tmp/cassette.json.gz"];
	```

* **Return static responses**

	Example:

	```objc
   [VCRURLSession setStaticResponseHandler:^VCRURLSessionResponse *_Nullable(NSURLRequest *_Nonnull request) {
       NSString *contentType = request.allHTTPHeaderFields[@"Content-Type"];
       if ([contentType hasPrefix:@"image/"]) {
           NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"test_image"]);
           return [VCRURLSessionResponse responseWithURL:request.URL statusCode:200 headerFields:nil data:imageData error:nil];
       }
       return nil;
   }];
	```

* **Recording filter**

	Example:

	```objc
   	VCRURLSessionCassette *cassette = [[VCRURLSessionCassette alloc] init];
   self.cassette.recordFilter = ^BOOL(NSURLRequest *request) {
       NSString *contentType = request.allHTTPHeaderFields[@"Content-Type"];
       // Do not record images
       return [contentType hasPrefix:@"image/"];
   };
	```

# License (MIT)

Copyright (C) 2016 Johannes Plunien

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
