//
//  OpenWeatherFreeClientTests.swift
//  OpenWeatherFreeClientTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

import XCTest
@testable import OpenWeatherFreeClient

// The API client unit tests

final class OpenWeatherFreeClientTests: XCTestCase {

    var sut: OpenWeatherFreeClient!
    var mockURLSession: MockURLSession!

    override func setUp() {
        sut = OpenWeatherFreeClient()
        mockURLSession = MockURLSession()
    }

    override func tearDown() {
        mockURLSession = nil
        sut = nil

        super.tearDown()
    }

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    func testTheFirstSuccess() { XCTAssertTrue(true, "It's done!") }

    func testOpenWeatherClient_Init() {

        // assert

        XCTAssertNil(sut.dataTask)
        XCTAssertNotNil(sut.session)

        XCTAssertTrue(sut.data == Data())
        XCTAssertTrue(sut.networkData == Data())
    }

    func testOpenWeatherClient_DataTask_Right() {

        // arrange

        sut.session = mockURLSession
        let dummyCallDetails = OpenWeatherDetails(appid: "code")

        // act

        try? sut.call(with: dummyCallDetails)

        // assert

        mockURLSession.verifyDataTask(
            with: URLRequest(url: URL(string: dummyCallDetails.urlString)!))
    }

    func testOpenWeatherClient_URL_Exception() {

        // arrange

        let sut = OpenWeatherFreeClient()
        let dummyCallDetails = OpenWeatherDetails(appid: "\\")

        // act, assert

        // simulate request
        XCTAssertThrowsError(try sut.call(with: dummyCallDetails)) { (error) in
            // catch exeption
            XCTAssertEqual(error as? NetworkClientError, NetworkClientError.invalidUrl)
        }
    }

    func testOpenWeatherClient_No_Data() {

        // arrange

        sut.session = mockURLSession
        let dummyCallDetails = OpenWeatherDetails(appid: "code")

        let expectedData: Result<Data, NetworkClientError> = .success(Data())
        var actualData: Result<Data, NetworkClientError> = .failure(.statusCode404)

        let onDataGivenInvoked = expectation(description: "onDataGiven closure invoked")
        sut.onDataGiven = { result in
            actualData = result
            onDataGivenInvoked.fulfill()
        }

        // act

        // simulate request
        try? sut.call(with: dummyCallDetails)
        // simulate response
        mockURLSession.dataTaskArgsCompletionHandler.first?(nil,
                                                            response(statusCode: 200),
                                                            nil)

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(sut.data, Data())
        XCTAssertEqual(String(describing: actualData), String(describing: expectedData))
    }

    func testOpenWeatherClient_StatusCodeNot200Not404() {

        // arrange

        sut.session = mockURLSession
        let dummyCallDetails = OpenWeatherDetails(appid: "code")

        let status_code = 404
        // let message = HTTPURLResponse.localizedString(forStatusCode: status_code)

        let expectedFailure: Result<Data, NetworkClientError> = .failure(.statusCode404)
        var actualFailure: Result<Data, NetworkClientError> = .success(Data())

        let happiness = loadTestJsonData()

        let onDataGivenInvoked = expectation(description: "onDataGiven closure invoked")
        sut.onDataGiven = { result in
            actualFailure = result
            onDataGivenInvoked.fulfill()
        }

        // act

        // simulate request
        try? sut.call(with: dummyCallDetails)
        // simulate response
        mockURLSession.dataTaskArgsCompletionHandler.first?(
            happiness, response(statusCode: status_code), nil)

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(sut.data, Data(), "Causing data update with failure status code!")
        XCTAssertEqual(String(describing: actualFailure),
                       String(describing: expectedFailure))
    }

    func testOpenWeatherClient_StatusCode200() {

        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherFreeClient()
        sut.session = mock
        let dummyCallDetails = OpenWeatherDetails(appid: "code")

        let happiness = loadTestJsonData()

        let expectedData: Result<Data, NetworkClientError> = .success(happiness)
        var actualData: Result<Data, NetworkClientError> = .success(Data())

        let onDataGivenInvoked = expectation(description: "onDataGiven closure invoked")

        sut.onDataGiven = { result in
            actualData = result
            onDataGivenInvoked.fulfill()
        }

        // act

        // simulate request
        try? sut.call(with: dummyCallDetails)
        // simulate response
        mock.dataTaskArgsCompletionHandler.first?(happiness, response(statusCode: 200), nil)

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(sut.data, happiness)
        XCTAssertEqual(String(describing: actualData), String(describing: expectedData))
    }
}
