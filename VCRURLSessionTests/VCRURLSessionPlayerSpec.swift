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
    var recordForRequestHandler: ((_ request: URLRequest?) -> VCRURLSessionRecord?)?

    @objc func record(for request: URLRequest) -> VCRURLSessionRecord? {
        return recordForRequestHandler?(request)
    }
}

class VCRURLSessionPlayerSpec: QuickSpec {
    let testSession = VCRURLSession.prepare(URLSession.shared)
    let testURL = URL(string: "http://www.google.com")!
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
                VCRURLSessionPlayer.startReplaying(with: self.testDelegate, mode: .normal)

                expect(VCRURLSessionPlayer.isReplaying()).to(beTrue())
            }

            it("returns offline error in strict mode") {
                VCRURLSessionPlayer.startReplaying(with: self.testDelegate, mode: .strict)

                waitUntil { done in
                    self.testSession.dataTask(with: self.testURL, completionHandler: { (data, response, error) in
                        expect((error as! NSError).domain).to(equal(NSURLErrorDomain))
                        expect((error as! NSError).code).to(equal(NSURLErrorNotConnectedToInternet))
                        expect(error).notTo(beNil())
                        done()
                    }).resume()
                }
            }

            it("returns response in normal mode") {
                VCRURLSessionPlayer.startReplaying(with: self.testDelegate, mode: .normal)

                waitUntil(timeout: 5) { done in
                    self.testSession.dataTask(with: self.testURL, completionHandler: { (data, response, error) in
                        expect(data).notTo(beNil())
                        expect(response).notTo(beNil())
                        expect(error).to(beNil())
                        done()
                    }).resume()
                }
            }

            it("sets played to true") {
                VCRURLSessionPlayer.startReplaying(with: self.testDelegate, mode: .normal)
                let record = VCRURLSessionRecord()
                self.testDelegate.recordForRequestHandler = {request in
                    return record
                }

                expect(record.played).to(beFalse())
                self.testSession.dataTask(with: self.testURL).resume()
                expect(record.played).toEventually(beTrue())
            }

            it("return the error only") {
                VCRURLSessionPlayer.startReplaying(with: self.testDelegate, mode: .normal)
                let record = VCRURLSessionRecord(requestID: 0, request: NSURLRequest() as URLRequest, responseTime: 0.0, response: HTTPURLResponse(), data: NSData() as Data, error: NSError(domain: "foo", code: 42, userInfo: nil))
                self.testDelegate.recordForRequestHandler = {request in
                    return record
                }

                waitUntil { done in
                    self.testSession.dataTask(with: self.testURL, completionHandler: { (data, response, error) in
                        expect(data).to(beNil())
                        expect(response).to(beNil())
                        expect((error as! NSError).domain).to(equal("foo"))
                        expect((error as! NSError).code).to(equal(42))
                        done()
                    }).resume()
                }
            }
        }
    }

}
