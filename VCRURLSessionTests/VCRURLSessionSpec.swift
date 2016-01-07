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

    override func spec() {
        afterEach {
            VCRURLSession.stopRecording()
            VCRURLSession.stopReplaying()
        }

        describe("cassette1.json") {
            describe("recording") {
                pending("run `ruby api.rb` and change `pending` to `describe` to generate the cassette") {
                    it("records all requests") {
                        let cassette = VCRURLSessionCassette()
                        VCRURLSession.startRecordingOnCassette(cassette)

                        let getRequest = NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:4567/")!)
                        let postRequest = NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:4567/")!)
                        postRequest.HTTPMethod = "POST"

                        // 1. GET /
                        self.testSession.dataTaskWithRequest(getRequest).resume()
                        expect(cassette.records.count).toEventually(equal(1))

                        // 2. POST /
                        postRequest.HTTPBody = "one".dataUsingEncoding(NSUTF8StringEncoding)
                        self.testSession.dataTaskWithRequest(postRequest).resume()
                        expect(cassette.records.count).toEventually(equal(2))

                        // 3. POST /
                        postRequest.HTTPBody = "two".dataUsingEncoding(NSUTF8StringEncoding)
                        self.testSession.dataTaskWithRequest(postRequest).resume()
                        expect(cassette.records.count).toEventually(equal(3))

                        // 4. GET /
                        self.testSession.dataTaskWithRequest(getRequest).resume()
                        expect(cassette.records.count).toEventually(equal(4))

                        cassette.writeToFile(VCRURLSessionTestsHelper.pathToCassetteWithName("cassette1.json"))
                    }
                }
            }

            describe("playing") {
                it("plays all records in correct order") {
                    var responseString: String?
                    let cassette = VCRURLSessionCassette.init(contentsOfFile: VCRURLSessionTestsHelper.pathToCassetteWithName("cassette1.json"))
                    VCRURLSession.startReplayingWithCassette(cassette)

                    let getRequest = NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:4567/")!)
                    let postRequest = NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:4567/")!)
                    postRequest.HTTPMethod = "POST"

                    // 1. GET /
                    self.testSession.dataTaskWithRequest(getRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String.init(data: data!, encoding: NSUTF8StringEncoding)
                    }).resume()
                    expect(responseString).toEventually(equal("[]"))

                    // 2. POST /
                    self.testSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String.init(data: data!, encoding: NSUTF8StringEncoding)
                    }).resume()
                    expect(responseString).toEventually(equal("Added new record: one"))

                    // 3. POST /
                    self.testSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String.init(data: data!, encoding: NSUTF8StringEncoding)
                    }).resume()
                    expect(responseString).toEventually(equal("Added new record: two"))

                    // 4. GET /
                    self.testSession.dataTaskWithRequest(getRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String.init(data: data!, encoding: NSUTF8StringEncoding)
                    }).resume()
                    expect(responseString).toEventually(equal("[\"one\",\"two\"]"))
                }
            }
        }
    }
}
