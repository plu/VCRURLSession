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
                let request = URLRequest(url: URL(string: "http://www.google.de")!)
                let cassette = VCRURLSessionCassette()

                cassette.recordFilter = {
                    expect($0).to(equal(request))
                    return true
                }

                cassette.record(request, responseTime: 0.0, response: nil, data: nil, error: nil)
            }

            it("records the request") {
                let request = URLRequest(url: URL(string: "http://www.google.de")!)
                let cassette = VCRURLSessionCassette()

                cassette.recordFilter = { _ in true }

                cassette.record(request, responseTime: 0.0, response: nil, data: nil, error: nil)

                expect(cassette.numberOfRecords).to(equal(1))
            }

            it("does not record the request") {
                let request = URLRequest(url: URL(string: "http://www.google.de")!)
                let cassette = VCRURLSessionCassette()

                cassette.recordFilter = { _ in false }

                cassette.record(request, responseTime: 0.0, response: nil, data: nil, error: nil)

                expect(cassette.numberOfRecords).to(equal(0))
            }
        }

        describe("userInfo") {
            it("stores and retrieves the userInfo dictionary") {
                let path = NSTemporaryDirectory().appendingFormat("cassette.json")

                let writeCassette = VCRURLSessionCassette()
                writeCassette.userInfo = ["foo": "bar"]
                writeCassette.write(toFile: path)

                let readCassette = VCRURLSessionCassette(contentsOfFile: path)
                expect(readCassette.userInfo as? Dictionary).to(equal(["foo": "bar"]))
            }
        }

        describe("recordingDate") {
            it("stores and retrieves the recordingDate") {
                let path = NSTemporaryDirectory().appendingFormat("cassette.json")

                let writeCassette = VCRURLSessionCassette()
                writeCassette.write(toFile: path)

                let readCassette = VCRURLSessionCassette(contentsOfFile: path)
                expect(readCassette.recordingDate).notTo(beNil())
            }
        }
    }
}
