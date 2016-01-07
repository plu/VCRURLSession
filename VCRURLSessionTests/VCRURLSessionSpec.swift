//
//  VCRURLSessionSpec.swift
//  VCRURLSession
//
//  Created by Plunien, Johannes on 06/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import Quick
import Nimble

class VCRURLSessionSpec: QuickSpec {
    let testSession = VCRURLSession.prepareURLSession(NSURLSession.sharedSession())
    let timeout = 5.0
    let testURL = NSURL.init(string: "https://s3.eu-central-1.amazonaws.com/plu-test-responses/users.json")!

    override func spec() {
        describe("startRecordingOnCassette") {
            it("stores the record") {
                let cassette = VCRURLSessionCassette()
                VCRURLSession.startRecordingOnCassette(cassette)
                self.testSession.dataTaskWithURL(self.testURL).resume()
                expect(cassette.records.count).toEventually(equal(1), timeout: self.timeout)

                let record = cassette.records.first!
                expect(record.data?.length).to(beGreaterThan(0))
                expect(record.request).to(beAKindOf(NSURLRequest.self))
                expect(record.response).to(beAKindOf(NSHTTPURLResponse.self))
                expect(record.error).to(beNil())
            }

            it("saves the cassette to file") {
                let cassette = VCRURLSessionCassette()
                VCRURLSession.startRecordingOnCassette(cassette)
                self.testSession.dataTaskWithURL(self.testURL).resume()
                expect(cassette.records.count).toEventually(equal(1), timeout: self.timeout)

                cassette.writeToFile("/tmp/users.json")
                expect(NSFileManager.defaultManager().fileExistsAtPath("/tmp/users.json")).to(beTrue())
            }
        }
    }
}
