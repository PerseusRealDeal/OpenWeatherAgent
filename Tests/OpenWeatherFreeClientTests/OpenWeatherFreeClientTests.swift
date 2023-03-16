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
        XCTAssertNil(sut.session)
        XCTAssertNil(sut.requestError)

        XCTAssertTrue(sut.data == Data())
        XCTAssertTrue(sut.networkData == Data())
    }

    func test_onDataGiven_called() {

        // arrange

        let sut = OpenWeatherFreeClient()
        let dummyCallDetails = OpenWeatherDetails(appid: "code")
        var isCalled = false

        sut.onDataGiven = { _ in isCalled = true }

        // act

        sut.call(with: dummyCallDetails)

        // assert

        XCTAssertTrue(isCalled)
    }

    // MARK: - The API Response checks
}
