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

final class OpenWeatherFreeClientTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    func test_the_first_success() { XCTAssertTrue(true, "It's done!") }

    // MARK: - The API Requests checks

    func test_OpenWeather_call_default_schemes() {

        // arrange

        let sut = weatherSchemeBase + weatherSchemeAttributes
        let requirement = "https://api.openweathermap.org/data/2.5/%@?lat=%@&lon=%@&appid=%@"

        // assert

        XCTAssertEqual(requirement, sut)
    }

    func test_OpenWeather_call_details_default_init() {

        // arrange

        let apikey = "code"

        let sut = OpenWeatherDetails(appid: apikey)
        let requirement = "https://api.openweathermap.org/data/2.5/" +
        "weather?lat=55.66&lon=85.62&appid=\(apikey)"

        // assert

        XCTAssertEqual(requirement, sut.urlString)

    }

    func test_OpenWeather_call_all_details_in_use() {

        // arrange

        let apikey = "code"
        let format: OpenWeatherURLFormat = .forecast
        let lat = 11.11
        let lon = 22.22
        let units: Units = .metric
        let lang:Lang = Lang.ru
        let mode: Mode = .xml

        let sut = OpenWeatherDetails(appid: apikey, format: format,
                                     lat: "\(lat)", lon: "\(lon)", units: units,
                                     lang: lang, mode: mode)

        let requirementScheme = "https://api.openweathermap.org/data/2.5/"
        let requirementSchemeAttributes = "%@?lat=%@&lon=%@&appid=%@&lang=%@&mode=%@&units=%@"

        let args: [String] = [format.rawValue, "\(lat)", "\(lon)", apikey,
                              lang.rawValue, mode.rawValue, units.rawValue]

        let requirement = String(format: requirementScheme + requirementSchemeAttributes,
                                 arguments: args)

        // assert

        XCTAssertEqual(requirement, sut.urlString)
    }

    // MARK: - The API Client checks

    func test_OpenWeatherFreeClient_init() {

        // arrange

        let sut = OpenWeatherFreeClient()

        // assert

        XCTAssertNil(sut.dataTask)
        XCTAssertNil(sut.session)
        XCTAssertNil(sut.requestError)

        XCTAssertTrue(sut.data == Data())
        XCTAssertTrue(sut.weatherData == Data())
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

    // MARK: - The API Responses checks
}
