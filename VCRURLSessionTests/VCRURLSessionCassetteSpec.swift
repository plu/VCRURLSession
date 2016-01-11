//
//  VCRURLSessionCassetteSpec.swift
//  VCRURLSession
//
//  Created by Plunien, Johannes on 11/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import Quick
import Nimble

class VCRURLSessionCassetteSpec: QuickSpec {
    override func spec() {
        describe("recordFilter") {
            it("passes in the request") {
                let request: NSURLRequest = NSURLRequest()
                let cassette = VCRURLSessionCassette()

                cassette.recordFilter = {
                    expect($0).to(equal(request))
                    return true
                }

                cassette.recordRequest(request, response: nil, data: nil, error: nil)
            }

            it("records the request") {
                let request: NSURLRequest = NSURLRequest()
                let cassette = VCRURLSessionCassette()

                cassette.recordFilter = { _ in true }

                cassette.recordRequest(request, response: nil, data: nil, error: nil)

                expect(cassette.records.count).to(equal(1))
            }

            it("does not record the request") {
                let request: NSURLRequest = NSURLRequest()
                let cassette = VCRURLSessionCassette()

                cassette.recordFilter = { _ in false }

                cassette.recordRequest(request, response: nil, data: nil, error: nil)

                expect(cassette.records.count).to(equal(0))
            }
        }

        describe("userInfo") {
            it("stores and retrieves the userInfo dictionary") {
                let path = NSTemporaryDirectory().stringByAppendingString("cassette.json")

                let writeCassette = VCRURLSessionCassette()
                writeCassette.userInfo = ["foo": "bar"]
                writeCassette.writeToFile(path)

                let readCassette = VCRURLSessionCassette.init(contentsOfFile: path)
                expect(readCassette.userInfo as? Dictionary).to(equal(["foo": "bar"]))
            }
        }
    }
}
