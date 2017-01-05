//
//  VCRURLSessionRecordSpec.swift
//  VCRURLSession
//
//  Created by Plunien, Johannes on 14/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import Quick
import Nimble

class VCRURLSessionRecordSpec: QuickSpec {
    override func spec() {
        describe("dictionaryValue") {
            let requestID: UInt = 5
            let url = URL(string: "http://www.google.de")!
            let request = URLRequest(url: url as URL)
            let responseTime = 0.5
            let error = NSError(domain: "foo.bar", code: 42, userInfo: nil)
            let data = "{\"foo\":1}".data(using: String.Encoding.utf8)
            let response = HTTPURLResponse(url: url as URL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let subject = VCRURLSessionRecord(requestID: requestID, request: request, responseTime: responseTime, response: response, data: data, error: error)

            it("includes responseTime") {
                expect(subject.dictionaryValue["responseTime"] as? Double).to(equal(0.5))
            }

            it("includes requestID") {
                expect(subject.dictionaryValue["requestID"] as? UInt).to(equal(5))
            }

            it("includes request") {
                let requestDictionaryValue = (request as NSURLRequest).vcrurlSession_dictionaryValue as NSDictionary
                expect(subject.dictionaryValue["request"] as? NSDictionary).to(equal(requestDictionaryValue))
            }

            it("includes response") {
                let responseDictionaryValue = response.vcrurlSession_dictionaryValue(with: data) as NSDictionary
                expect(subject.dictionaryValue["response"] as? NSDictionary).to(equal(responseDictionaryValue))
            }

            it("includes error") {
                let errorDictionaryValue = error.vcrurlSession_dictionaryValue as NSDictionary
                expect(subject.dictionaryValue["error"] as? NSDictionary).to(equal(errorDictionaryValue))
            }
        }
    }
}
