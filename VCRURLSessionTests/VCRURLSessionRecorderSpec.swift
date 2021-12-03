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
    var recordHandler: ((_ request: URLRequest?, _ response: HTTPURLResponse?, _ data: Data?, _ error: Error?) -> Void)?

    func record(_ request: URLRequest, responseTime: TimeInterval, response: HTTPURLResponse?, data: Data?, error: Error?) -> Bool {
        recordHandler!(request, response, data, error)
        return true
    }
}

class VCRURLSessionRecorderSpec: QuickSpec {
    let testSession = VCRURLSessionController.prepare(URLSession.shared)
    let testURL = URL(string: "http://www.google.com")!
    let testDelegate = VCRURLSessionRecorderTestDelegate()

    override func spec() {
        beforeEach {
            VCRURLSessionController.stopRecording()
            VCRURLSessionController.stopReplaying()
        }

        describe("stopRecording") {
            it("sets isRecording to false") {
                VCRURLSessionRecorder.stopRecording()

                expect(VCRURLSessionRecorder.isRecording()).to(beFalse())
            }
        }

        describe("startRecordingWithDelegate") {
            it("sets isRecording to true") {
                VCRURLSessionRecorder.startRecording(with: self.testDelegate)

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
                VCRURLSessionRecorder.startRecording(with: self.testDelegate)
                self.testSession.dataTask(with: self.testURL).resume()

                expect(recordHandlerCalled).toEventually(beTrue(), timeout: .seconds(5))
            }
        }
    }
}
