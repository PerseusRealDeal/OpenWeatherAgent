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

    func test_OpenWeatherFreeClient_init() {

        // arrange

        let sut = OpenWeatherFreeClient()

        // assert

        XCTAssertNil(sut.dataTask)

        XCTAssertTrue(sut.data == Data())
        XCTAssertTrue(sut.networkData == Data())
    }

    func test_call_with_invalid_url() {

        // arrange

        let sut = OpenWeatherFreeClient()
        let dummyCallDetails = OpenWeatherDetails(appid: "\\")

        // act, assert

        XCTAssertThrowsError(try sut.call(with: dummyCallDetails)) { (error) in
            XCTAssertEqual(error as? NetworkClientError, NetworkClientError.invalidUrl)
        }
    }
/*
    func test_onDataGiven_called() {

        // arrange

        let sut = OpenWeatherFreeClient()
        let dummyCallDetails = OpenWeatherDetails(appid: "code")
        print(dummyCallDetails.urlString)
        var isCalled = false

        sut.onDataGiven = { _ in isCalled = true }

        // act

        try? sut.call(with: dummyCallDetails)

        // assert

        XCTAssertTrue(isCalled)
    }
*/
    // MARK: - The API Response checks
}

// THIS EXTENSION NOT FOR REGULAR USE.

extension OpenWeatherFreeClientTests {

    #if false

    func test_onDataGiven_called_with_network_connection() {

        // arrange

        let apikey =  "The API key"

        let client = OpenWeatherFreeClient()
        let callDetails = OpenWeatherDetails(appid: apikey)

        let onDataGivenInvoked = expectation(description: "onDataGiven closure invoked")

        client.onDataGiven = { result in

            switch result {
            case .success(let weatherData):
                print("""
                    DATA: BEGIN
                    \(String(decoding: weatherData, as: UTF8.self))
                    DATA: END
                    """)
            case .failure(let error):
                switch error {
                case .failedRequest(let message):
                    print(message)
                default:
                    break
                }
            }

            onDataGivenInvoked.fulfill()
        }

        // act

        try? client.call(with: callDetails)
        waitForExpectations(timeout: 3)

        // assert

        XCTAssertTrue(client.data != Data(), "There's nothing of data!")
    }

    #endif
}
