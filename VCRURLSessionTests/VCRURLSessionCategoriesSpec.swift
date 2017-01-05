//
//  VCRURLSessionCategoriesSpec.swift
//  VCRURLSession
//
//  Created by Plunien, Johannes on 07/01/16.
//  Copyright © 2016 Johannes Plunien. All rights reserved.
//

import Quick
import Nimble

class VCRURLSessionCategoriesSpec: QuickSpec {
    override func spec() {
        describe("NSError+VCRURLSession") {
            let code = 42
            let domain = "foo"
            let userInfo = ["foo": "bar"]

            describe("VCRURLSession_dictionaryValue") {
                let error = NSError(domain: domain, code: code, userInfo: userInfo)
                let result: Dictionary = error.vcrurlSession_dictionaryValue

                it("stores domain") {
                    expect(result["domain"] as? String).to(equal(domain))
                }

                it("stores code") {
                    expect(result["code"] as? Int).to(equal(code))
                }

                it("stores userInfo") {
                    let userInfoData = NSData(base64Encoded: result["userInfo"] as! String, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    let decodedUserInfo = NSKeyedUnarchiver.unarchiveObject(with: userInfoData as Data)
                    expect(decodedUserInfo as? Dictionary).to(equal(userInfo))
                }
            }
        }

        describe("NSHTTPURLResponse+VCRURLSession") {
            describe("VCRURLSession_dictionaryValue") {
                let url = NSURL(string: "http://www.google.com")!
                let statusCode = 200
                var headers = ["Content-Type": "application/json"]

                it("stores statusCode") {
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: nil) as NSDictionary

                    expect(result["statusCode"] as? Int).to(equal(statusCode))
                }

                it("stores url") {
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: nil) as NSDictionary

                    expect(result["url"] as? String).to(equal(url.absoluteString))
                }

                it("stores headers") {
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: nil) as NSDictionary

                    expect(result["headers"] as? Dictionary).to(equal(headers))
                }

                it("stores text body") {
                    headers["Content-Type"] = "text/plain"
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: "foo".data(using: String.Encoding.utf8)) as NSDictionary

                    expect(result["body"] as? String).to(equal("foo"))
                }

                it("stores form encoded body") {
                    headers["Content-Type"] = "application/x-www-form-urlencoded"
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: "foo".data(using: String.Encoding.utf8)) as NSDictionary

                    expect(result["body"] as? String).to(equal("foo"))
                }

                it("stores json encoded body") {
                    headers["Content-Type"] = "application/json"
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: "{\"foo\":1,\"bar\":2}".data(using: String.Encoding.utf8)) as NSDictionary

                    expect(result["body"] as? Dictionary).to(equal(["foo": 1, "bar": 2]))
                }

                it("stores invalid json encoded body") {
                    headers["Content-Type"] = "application/json"
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: "{\"foo\":1,\"bar\":".data(using: String.Encoding.utf8)) as NSDictionary

                    expect(result["body"] as? String).to(equal("{\"foo\":1,\"bar\":"))
                }

                it("stores binary encoded body") {
                    headers["Content-Type"] = "application/binary"
                    let response = HTTPURLResponse(url: url as URL, statusCode: statusCode, httpVersion: nil, headerFields: headers)
                    let result: NSDictionary = response!.vcrurlSession_dictionaryValue(with: "foo".data(using: String.Encoding.utf8)) as NSDictionary

                    expect(result["body"] as? String).to(equal("Zm9v"))
                }
            }
        }

        describe("NSURLRequest+VCRURLSession") {
            describe("VCRURLSession_dictionaryValue") {
                let url = NSURL(string: "http://www.google.com")!
                let request = NSMutableURLRequest(url: url as URL, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)

                it("stores url") {
                    let result = request.vcrurlSession_dictionaryValue

                    expect(result["url"] as? String).to(equal(url.absoluteString))
                }

                it("stores headers") {
                    request.allHTTPHeaderFields = ["Content-Type": "application/json"]
                    let result = request.vcrurlSession_dictionaryValue

                    expect(result["headers"] as? Dictionary).to(equal(request.allHTTPHeaderFields))
                }

                it("stores method") {
                    request.httpMethod = "POST"
                    let result = request.vcrurlSession_dictionaryValue

                    expect(result["method"] as? String).to(equal(request.httpMethod))
                }
            }
        }
    }
}
