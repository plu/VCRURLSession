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
    let testSession = VCRURLSessionController.prepare(URLSession.shared)

    override func spec() {
        beforeEach {
            VCRURLSessionController.stopRecording()
            VCRURLSessionController.stopReplaying()
        }

        describe("errors.json") {
            let cassettePath = VCRURLSessionTestsHelper.pathToCassette(withName: "errors.json")

            describe("recording") {
                pending("change `pending` to `describe` to generate the cassette") {
                    it("records all requests") {
                        let cassette = VCRURLSessionCassette()
                        VCRURLSessionController.startRecording(on: cassette)

                        // 1. Invalid port
                        self.testSession.dataTask(with: NSMutableURLRequest(url: NSURL(string: "http://localhost:70000/")! as URL) as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(1))

                        // 2. Invalid scheme
                        self.testSession.dataTask(with: NSMutableURLRequest(url: NSURL(string: "asdf://localhost/")! as URL) as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(2))

                        // 3. Invalid domain
                        self.testSession.dataTask(with: NSMutableURLRequest(url: NSURL(string: "http://invalid.plunien.com/")! as URL) as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(3))

                        cassette.write(toFile: cassettePath!)
                    }
                }
            }

            describe("playing") {
                it("plays all records in correct order") {
                    var responseError: NSError?
                    let cassette = VCRURLSessionCassette(contentsOfFile: cassettePath!)
                    VCRURLSessionController.startReplaying(with: cassette, mode: .strict)

                    // 1. Invalid port
                    self.testSession.dataTask(with: NSMutableURLRequest(url: NSURL(string: "http://localhost:70000/")! as URL) as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseError = error as NSError?
                    }).resume()
                    expect(responseError?.code).toEventually(equal(-1004))
                    expect(responseError?.localizedDescription).to(equal("Could not connect to the server."))

                    // 2. Invalid scheme
                    self.testSession.dataTask(with: NSMutableURLRequest(url: NSURL(string: "asdf://localhost/")! as URL) as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseError = error as NSError?
                    }).resume()
                    expect(responseError?.code).toEventually(equal(-1002))
                    expect(responseError?.localizedDescription).to(equal("unsupported URL"))

                    // 3. Invalid domain
                    self.testSession.dataTask(with: NSMutableURLRequest(url: NSURL(string: "http://invalid.plunien.com/")! as URL) as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseError = error as NSError?
                    }).resume()
                    expect(responseError?.code).toEventually(equal(-1003))
                    expect(responseError?.localizedDescription).to(equal("A server with the specified hostname could not be found."))
                }
            }
        }

        describe("cassette1.json") {
            let cassettePath = VCRURLSessionTestsHelper.pathToCassette(withName: "cassette1.json")

            describe("recording") {
                pending("run `ruby api.rb` and change `pending` to `describe` to generate the cassette") {
                    it("records all requests") {
                        let cassette = VCRURLSessionCassette()
                        VCRURLSessionController.startRecording(on: cassette)

                        let getRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/")! as URL)
                        let postRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/")! as URL)
                        postRequest.httpMethod = "POST"

                        // 1. GET /
                        self.testSession.dataTask(with: getRequest as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(1))

                        // 2. POST /
                        postRequest.httpBody = "one".data(using: String.Encoding.utf8)
                        self.testSession.dataTask(with: postRequest as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(2))

                        // 3. POST /
                        postRequest.httpBody = "two".data(using: String.Encoding.utf8)
                        self.testSession.dataTask(with: postRequest as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(3))

                        // 4. GET /
                        self.testSession.dataTask(with: getRequest as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(4))

                        cassette.write(toFile: cassettePath!)
                    }
                }
            }

            describe("playing") {
                it("plays all records in correct order") {
                    var responseString: String?
                    let cassette = VCRURLSessionCassette(contentsOfFile: cassettePath!)
                    VCRURLSessionController.startReplaying(with: cassette, mode: .strict)

                    let getRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/")! as URL)
                    let postRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/")! as URL)
                    postRequest.httpMethod = "POST"

                    // 1. GET /
                    self.testSession.dataTask(with: getRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String(data: data!, encoding: String.Encoding.utf8)
                    }).resume()
                    expect(responseString).toEventually(equal("[]"))

                    // 2. POST /
                    self.testSession.dataTask(with: postRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String(data: data!, encoding: String.Encoding.utf8)
                    }).resume()
                    expect(responseString).toEventually(equal("Added new record: one"))

                    // 3. POST /
                    self.testSession.dataTask(with: postRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String(data: data!, encoding: String.Encoding.utf8)
                    }).resume()
                    expect(responseString).toEventually(equal("Added new record: two"))

                    // 4. GET /
                    self.testSession.dataTask(with: getRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String(data: data!, encoding: String.Encoding.utf8)
                    }).resume()
                    expect(responseString).toEventually(equal("[\"one\",\"two\"]"))
                }
            }
        }

        describe("cassette2.json") {
            let cassettePath = VCRURLSessionTestsHelper.pathToCassette(withName: "cassette2.json")

            describe("recording") {
                pending("run `ruby api.rb` and change `pending` to `describe` to generate the cassette") {
                    it("records all requests") {
                        let cassette = VCRURLSessionCassette()
                        VCRURLSessionController.startRecording(on: cassette)

                        let getRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/sleep")! as URL)

                        // 1. GET /
                        self.testSession.dataTask(with: getRequest as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(1))

                        cassette.write(toFile: cassettePath!)
                    }
                }
            }

            describe("playing") {
                it("plays all records with correct responseTime delay") {
                    let cassette = VCRURLSessionCassette(contentsOfFile: cassettePath!)
                    VCRURLSessionController.startReplaying(with: cassette, mode: .strict)

                    let getRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/sleep")! as URL)
                    let startTime = NSDate.timeIntervalSinceReferenceDate
                    var responseTime = 0.0

                    // 1. GET /
                    self.testSession.dataTask(with: getRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseTime = NSDate.timeIntervalSinceReferenceDate - startTime
                    }).resume()
                    expect(responseTime).toEventually(beGreaterThan(0.5))
                }

                it("plays all records with correct speed") {
                    let cassette = VCRURLSessionCassette(contentsOfFile: cassettePath!)
                    cassette.replaySpeed = 2.0
                    VCRURLSessionController.startReplaying(with: cassette, mode: .strict)

                    let getRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/sleep")! as URL)
                    let startTime = NSDate.timeIntervalSinceReferenceDate
                    var responseTime = 0.0

                    // 1. GET /
                    self.testSession.dataTask(with: getRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseTime = NSDate.timeIntervalSinceReferenceDate - startTime
                    }).resume()
                    expect(responseTime).toEventually(beGreaterThan(0.25))
                    expect(responseTime).toEventually(beLessThan(0.5))
                }
            }
        }

        describe("cassette3.json") {
            let cassettePath = VCRURLSessionTestsHelper.pathToCassette(withName: "cassette3.json")

            describe("recording") {
                pending("run `ruby api.rb` and change `pending` to `describe` to generate the cassette") {
                    it("records two requests") {
                        let cassette = VCRURLSessionCassette()
                        VCRURLSessionController.startRecording(on: cassette)

                        let getRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/")! as URL)

                        // 1. GET /
                        self.testSession.dataTask(with: getRequest as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(1))

                        // 2. GET /
                        self.testSession.dataTask(with: getRequest as URLRequest).resume()
                        expect(cassette.numberOfRecords).toEventually(equal(2))

                        cassette.write(toFile: cassettePath!)
                    }
                }
            }

            describe("playing") {
                it("plays one record") {
                    var responseString: String?
                    let cassette = VCRURLSessionCassette(contentsOfFile: cassettePath!)
                    VCRURLSessionController.startReplaying(with: cassette, mode: .strict)

                    let getRequest = NSMutableURLRequest(url: NSURL(string: "http://localhost:4567/")! as URL)

                    // 1. GET /
                    self.testSession.dataTask(with: getRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                        responseString = String(data: data!, encoding: String.Encoding.utf8)
                    }).resume()
                    expect(responseString).toEventually(equal("[]"))

                    expect(cassette.numberOfRecords).to(equal(2))
                    expect(cassette.numberOfPlayedRecords).to(equal(1))
                }
            }
        }
        
    }
}
