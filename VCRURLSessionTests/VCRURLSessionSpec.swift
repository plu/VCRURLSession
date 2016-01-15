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
        beforeEach {
            VCRURLSession.stopRecording()
            VCRURLSession.stopReplaying()
        }

        describe("errors.json") {
            let cassettePath = VCRURLSessionTestsHelper.pathToCassetteWithName("errors.json")

            describe("recording") {
                pending("change `pending` to `describe` to generate the cassette") {
                    it("records all requests") {
                        let cassette = VCRURLSessionCassette()
                        VCRURLSession.startRecordingOnCassette(cassette)

                        // 1. Invalid port
                        self.testSession.dataTaskWithRequest(NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:70000/")!)).resume()
                        expect(cassette.records.count).toEventually(equal(1))

                        // 2. Invalid scheme
                        self.testSession.dataTaskWithRequest(NSMutableURLRequest.init(URL: NSURL.init(string: "asdf://localhost/")!)).resume()
                        expect(cassette.records.count).toEventually(equal(2))

                        // 3. Invalid domain
                        self.testSession.dataTaskWithRequest(NSMutableURLRequest.init(URL: NSURL.init(string: "http://invalid.plunien.com/")!)).resume()
                        expect(cassette.records.count).toEventually(equal(3))

                        cassette.writeToFile(cassettePath)
                    }
                }
            }

            describe("playing") {
                it("plays all records in correct order") {
                    var responseError: NSError?
                    let cassette = VCRURLSessionCassette.init(contentsOfFile: cassettePath)
                    VCRURLSession.startReplayingWithCassette(cassette, mode: .Strict)

                    // 1. Invalid port
                    self.testSession.dataTaskWithRequest(NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:70000/")!), completionHandler: { (data, response, error) -> Void in
                        responseError = error
                    }).resume()
                    expect(responseError?.code).toEventually(equal(-1004))
                    expect(responseError?.localizedDescription).to(equal("Could not connect to the server."))

                    // 2. Invalid scheme
                    self.testSession.dataTaskWithRequest(NSMutableURLRequest.init(URL: NSURL.init(string: "asdf://localhost/")!), completionHandler: { (data, response, error) -> Void in
                        responseError = error
                    }).resume()
                    expect(responseError?.code).toEventually(equal(-1002))
                    expect(responseError?.localizedDescription).to(equal("unsupported URL"))

                    // 3. Invalid domain
                    self.testSession.dataTaskWithRequest(NSMutableURLRequest.init(URL: NSURL.init(string: "http://invalid.plunien.com/")!), completionHandler: { (data, response, error) -> Void in
                        responseError = error
                    }).resume()
                    expect(responseError?.code).toEventually(equal(-1003))
                    expect(responseError?.localizedDescription).to(equal("A server with the specified hostname could not be found."))
                }
            }
        }

        describe("cassette1.json") {
            let cassettePath = VCRURLSessionTestsHelper.pathToCassetteWithName("cassette1.json")

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

                        cassette.writeToFile(cassettePath)
                    }
                }
            }

            describe("playing") {
                it("plays all records in correct order") {
                    var responseString: String?
                    let cassette = VCRURLSessionCassette.init(contentsOfFile: cassettePath)
                    VCRURLSession.startReplayingWithCassette(cassette, mode: .Strict)

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

        describe("cassette2.json") {
            let cassettePath = VCRURLSessionTestsHelper.pathToCassetteWithName("cassette2.json")

            describe("recording") {
                pending("run `ruby api.rb` and change `pending` to `describe` to generate the cassette") {
                    it("records all requests") {
                        let cassette = VCRURLSessionCassette()
                        VCRURLSession.startRecordingOnCassette(cassette)

                        let getRequest = NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:4567/sleep")!)

                        // 1. GET /
                        self.testSession.dataTaskWithRequest(getRequest).resume()
                        expect(cassette.records.count).toEventually(equal(1))

                        cassette.writeToFile(cassettePath)
                    }
                }
            }

            describe("playing") {
                it("plays all records with correct responseTime delay") {
                    let cassette = VCRURLSessionCassette.init(contentsOfFile: cassettePath)
                    VCRURLSession.startReplayingWithCassette(cassette, mode: .Strict)

                    let getRequest = NSMutableURLRequest.init(URL: NSURL.init(string: "http://localhost:4567/sleep")!)
                    let startTime = NSDate.timeIntervalSinceReferenceDate()
                    var responseTime = 0.0

                    // 1. GET /
                    self.testSession.dataTaskWithRequest(getRequest, completionHandler: { (data, response, error) -> Void in
                        responseTime = NSDate.timeIntervalSinceReferenceDate() - startTime
                    }).resume()
                    expect(responseTime).toEventually(beGreaterThan(0.5))
                }
            }
        }
    }
}
