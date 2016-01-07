//
//  VCRURLSessionPlayerSpec.swift
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import Quick
import Nimble

class VCRURLSessionPlayerTestDelegate: NSObject, VCRURLSessionPlayerDelegate {
    var recordForRequestHandler: ((request: NSURLRequest!) -> VCRURLSessionRecord?)?

    @objc func recordForRequest(request: NSURLRequest) -> VCRURLSessionRecord? {
        return recordForRequestHandler?(request: request)
    }
}

class VCRURLSessionPlayerSpec: QuickSpec {
    let testSession = VCRURLSession.prepareURLSession(NSURLSession.sharedSession())
    let testURL = NSURL.init(string: "http://www.google.com")!
    let testDelegate = VCRURLSessionPlayerTestDelegate()

    override func spec() {
        beforeEach {
            VCRURLSession.stopRecording()
            VCRURLSession.stopReplaying()
        }

        describe("stopReplaying") {
            it("sets isReplaying to false") {
                VCRURLSessionPlayer.stopReplaying()

                expect(VCRURLSessionPlayer.isReplaying()).to(beFalse())
            }
        }

        describe("startRecordingWithDelegate") {
            it("sets isReplaying to true") {
                VCRURLSessionPlayer.startReplayingWithDelegate(self.testDelegate, mode: .Normal)

                expect(VCRURLSessionPlayer.isReplaying()).to(beTrue())
            }

            it("returns offline error in strict mode") {
                VCRURLSessionPlayer.startReplayingWithDelegate(self.testDelegate, mode: .Strict)

                waitUntil { done in
                    self.testSession.dataTaskWithURL(self.testURL, completionHandler: { (data, response, error) in
                        expect(error?.domain).to(equal(NSURLErrorDomain))
                        expect(error?.code).to(equal(NSURLErrorNotConnectedToInternet))
                        expect(error).notTo(beNil())
                        done()
                    }).resume()
                }
            }

            it("returns response in normal mode") {
                VCRURLSessionPlayer.startReplayingWithDelegate(self.testDelegate, mode: .Normal)

                waitUntil(timeout: 5) { done in
                    self.testSession.dataTaskWithURL(self.testURL, completionHandler: { (data, response, error) in
                        expect(data).notTo(beNil())
                        expect(response).notTo(beNil())
                        expect(error).to(beNil())
                        done()
                    }).resume()
                }
            }

            it("sets played to true") {
                VCRURLSessionPlayer.startReplayingWithDelegate(self.testDelegate, mode: .Normal)
                let record = VCRURLSessionRecord()
                self.testDelegate.recordForRequestHandler = {request in
                    return record
                }

                expect(record.played).to(beFalse())
                self.testSession.dataTaskWithURL(self.testURL).resume()
                expect(record.played).toEventually(beTrue())
            }

            it("return the error only") {
                VCRURLSessionPlayer.startReplayingWithDelegate(self.testDelegate, mode: .Normal)
                let record = VCRURLSessionRecord(request: NSURLRequest(), response: NSHTTPURLResponse(), data: NSData(), error: NSError(domain: "foo", code: 42, userInfo: nil))
                self.testDelegate.recordForRequestHandler = {request in
                    return record
                }

                waitUntil { done in
                    self.testSession.dataTaskWithURL(self.testURL, completionHandler: { (data, response, error) in
                        expect(data).to(beNil())
                        expect(response).to(beNil())
                        expect(error?.domain).to(equal("foo"))
                        expect(error?.code).to(equal(42))
                        done()
                    }).resume()
                }
            }
        }
    }

}
