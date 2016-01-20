//
//  VCRURLSessionRecorderSpec.swift
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import Quick
import Nimble

class VCRURLSessionRecorderTestDelegate: NSObject, VCRURLSessionRecorderDelegate {
    var recordHandler: ((request: NSURLRequest!, response: NSHTTPURLResponse!, data: NSData!, error: NSError!) -> Void)?

    @objc func recordRequest(request: NSURLRequest, responseTime: NSTimeInterval, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Bool {
        recordHandler!(request: request, response: response, data: data, error: error)
        return true
    }
}

class VCRURLSessionRecorderSpec: QuickSpec {
    let testSession = VCRURLSession.prepareURLSession(NSURLSession.sharedSession())
    let testURL = NSURL.init(string: "http://www.google.com")!
    let testDelegate = VCRURLSessionRecorderTestDelegate()

    override func spec() {
        beforeEach {
            VCRURLSession.stopRecording()
            VCRURLSession.stopReplaying()
        }

        describe("stopRecording") {
            it("sets isRecording to false") {
                VCRURLSessionRecorder.stopRecording()

                expect(VCRURLSessionRecorder.isRecording()).to(beFalse())
            }
        }

        describe("startRecordingWithDelegate") {
            it("sets isRecording to true") {
                VCRURLSessionRecorder.startRecordingWithDelegate(self.testDelegate)

                expect(VCRURLSessionRecorder.isRecording()).to(beTrue())
            }

            it("calls the delegate") {
                var recordHandlerCalled = false
                self.testDelegate.recordHandler = {request, response, data, error in
                    recordHandlerCalled = true
                    expect(request).notTo(beNil())
                    expect(response).notTo(beNil())
                    expect(data).notTo(beNil())
                    expect(error).to(beNil())
                }
                VCRURLSessionRecorder.startRecordingWithDelegate(self.testDelegate)
                self.testSession.dataTaskWithURL(self.testURL).resume()

                expect(recordHandlerCalled).toEventually(beTrue(), timeout: 5)
            }
        }
    }
}
