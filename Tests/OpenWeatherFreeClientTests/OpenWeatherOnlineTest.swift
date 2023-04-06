//
//  OpenWeatherOnlineTest.swift
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

/* THIS EXTENSION NOT FOR REGULAR USE

 Instructions:

 step 1: change #if from false to true
 step 2: give a real api key
 step 3: run test

*/

@testable import OpenWeatherFreeClient

extension OpenWeatherFreeClientTests {

    #if false

    func test_onDataGiven_called_with_network_connection() {

        // arrange

        let apikey = "The API key"

        let client = OpenWeatherFreeClient()
        let callDetails = OpenWeatherDetails(appid: apikey)

        let onDataGivenInvoked = expectation(description: "onDataGiven closure invoked")

        client.onDataGiven = { result in

            switch result {
            case .success(let weatherData):
                PerseusLogger.message("""
                    DATA: BEGIN
                    \(String(decoding: weatherData, as: UTF8.self))
                    DATA: END
                    """)
            case .failure(let error):
                switch error {
                case .failedRequest(let message):
                    PerseusLogger.message(message, .error)
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
