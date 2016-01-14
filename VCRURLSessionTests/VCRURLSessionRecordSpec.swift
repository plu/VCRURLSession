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
            let url = NSURL.init(string: "http://www.google.de")!
            let request = NSURLRequest(URL: url)
            let responseTime = 0.5
            let error = NSError.init(domain: "foo.bar", code: 42, userInfo: nil)
            let data = "{\"foo\":1}".dataUsingEncoding(NSUTF8StringEncoding)
            let response = NSHTTPURLResponse.init(URL: url, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
            let subject = VCRURLSessionRecord.init(requestID: requestID, request: request, responseTime: responseTime, response: response, data: data, error: error)

            it("includes responseTime") {
                expect(subject.dictionaryValue["responseTime"] as? Double).to(equal(0.5))
            }

            it("includes requestID") {
                expect(subject.dictionaryValue["requestID"] as? UInt).to(equal(5))
            }

            it("includes request") {
                expect(subject.dictionaryValue["request"] as? NSDictionary).to(equal(request.VCRURLSession_dictionaryValue))
            }

            it("includes response") {
                expect(subject.dictionaryValue["response"] as? NSDictionary).to(equal(response.VCRURLSession_dictionaryValueWithData(data)))
            }

            it("includes error") {
                expect(subject.dictionaryValue["error"] as? NSDictionary).to(equal(error.VCRURLSession_dictionaryValue))
            }
        }
    }
}
