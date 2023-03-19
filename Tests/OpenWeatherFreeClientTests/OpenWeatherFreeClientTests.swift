//
//  OpenWeatherFreeClientTests.swift
//  OpenWeatherFreeClientTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk.
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

import XCTest
@testable import OpenWeatherFreeClient

// The API Client checks

final class OpenWeatherFreeClientTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    func test_OpenWeatherClient_init() {

        // arrange

        let sut = OpenWeatherFreeClient()

        // assert

        XCTAssertNil(sut.dataTask)
        XCTAssertNotNil(sut.session)

        XCTAssertTrue(sut.data == Data())
        XCTAssertTrue(sut.networkData == Data())
    }

    func test_OpenWeatherClient_should_make_data_task() {

        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherFreeClient(mock)
        let dummyCallDetails = OpenWeatherDetails(appid: "code")

        // act

        try? sut.call(with: dummyCallDetails)

        // assert

        mock.verifyDataTask(with: URLRequest(url: URL(string: dummyCallDetails.urlString)!))
    }

    func test_OpenWeatherClient_should_throw_exception_with_invalid_url() {

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

    func test_OpenWeatherClient_should_give_no_data_if_error() {

        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherFreeClient(mock)
        let dummyCallDetails = OpenWeatherDetails(appid: "code")

        let expectedFailure: Result<Data, NetworkClientError> =
            .failure(.failedRequest("DUMMY"))
        var actualFailure: Result<Data, NetworkClientError> =
            .success(Data())

        let onDataGivenInvoked = expectation(description: "onDataGiven closure invoked")
        sut.onDataGiven = { result in
            actualFailure = result
            onDataGivenInvoked.fulfill()
        }

        // act

        // simulate request
        try? sut.call(with: dummyCallDetails)
        // simulate response
        mock.dataTaskArgsCompletionHandler.first?(nil, nil, TestError(message: "DUMMY"))

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(sut.data, Data())
        XCTAssertEqual(String(describing: actualFailure), String(describing: expectedFailure))
    }

    func test_OpenWeatherClient_withResponse_statusCodeNot200_shouldReportFailure() {

        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherFreeClient(mock)
        let dummyCallDetails = OpenWeatherDetails(appid: "code")

        let status_code = 404
        let message = HTTPURLResponse.localizedString(forStatusCode: status_code)

        let expectedFailure: Result<Data, NetworkClientError> =
            .failure(.failedRequest(message))
        var actualFailure: Result<Data, NetworkClientError> =
            .success(Data())

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
        mock.dataTaskArgsCompletionHandler.first?(happiness,
                                                  response(statusCode: status_code), nil)

        waitForExpectations(timeout: 0.01)

        // assert

        XCTAssertEqual(sut.data, Data(), "Causing data update with failure status code!")
        XCTAssertEqual(String(describing: actualFailure),
                       String(describing: expectedFailure))
    }

    func test_OpenWeatherClient_should_give_data_with_statusCode200_and_no_error() {

        // arrange

        let mock = MockURLSession()
        let sut = OpenWeatherFreeClient(mock)
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

    // MARK: - The API Response checks
}

