//
//  OpenWeatherOnlineTest.swift
//  OpenWeatherAgentTests
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
@testable import OpenWeatherAgent

// The API Client checks

/* THIS EXTENSION NOT FOR REGULAR USE

 Instructions:

 step 1: change #if from false to true
 step 2: give it a real api key
 step 3: run test

*/

extension OpenWeatherAgentTests {

    #if false // 1. true to unlock, false to lock

    func test_OpenWeatherAgent_real_network_connection() { // 3. Run

        // arrange

        let apikey = "" // 2. The API key

        let client = OpenWeatherAgent()
        let callDetails = OpenWeatherRequestData(appid: apikey)

        let onDataGivenInvoked = expectation(description: "onDataGiven closure invoked")

        client.onDataGiven = { result in

            switch result {
            case .success(let weatherData):
                log.message("OpenWeatherAgentTests:\(#function):\(result)")
            case .failure(let error):
                var errStr = ""
                switch error {
                case .failedRequest(let errText):
                    errStr = errText
                case .failedResponse(let errText):
                    errStr = errText
                case .invalidUrl:
                    errStr = "invalidUrl"
                case .statusCode404:
                    errStr = "statusCode404"
                }
                log.message("OpenWeatherAgentTests:\(#function): \(errStr)", .error)
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
