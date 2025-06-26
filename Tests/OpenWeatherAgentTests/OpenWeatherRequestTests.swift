//
//  OpenWeatherRequestTests.swift
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

// The API Request checks

final class OpenWeatherRequestTests: XCTestCase {

    // func test_zero() { XCTFail("Tests not yet implemented in \(type(of: self)).") }

    func test_OpenWeatherRequest_default_URL() {

        // arrange

        let sut = weatherSchemeBase + weatherSchemeAttributes
        let requirement = "https://api.openweathermap.org/data/2.5/%@?lat=%@&lon=%@&appid=%@"

        // assert

        XCTAssertEqual(requirement, sut)
    }

    func test_OpenWeatherRequest_default_init() {

        // arrange

        let apikey = "code"

        let sut = OpenWeatherRequestData(appid: apikey)
        let requirement = "https://api.openweathermap.org/data/2.5/" +
        "weather?lat=55.66&lon=85.62&appid=\(apikey)"

        // assert

        XCTAssertEqual(requirement, sut.urlString)

    }

    func test_OpenWeatherRequest_all_URL_parameters() {

        // arrange

        let apikey = "code"
        let format: OpenWeatherRequest = .forecast
        let lat = 11.11
        let lon = 22.22
        let units: Units = .metric
        let lang: Lang = Lang.ru
        let mode: Mode = .xml
        let cnt = 1

        var sut = OpenWeatherRequestData(appid: apikey,
                                         format: format,
                                         lat: "\(lat)",
                                         lon: "\(lon)",
                                         units: units,
                                         lang: lang,
                                         mode: mode)
        sut.cnt = cnt

        let requirementScheme = "https://api.openweathermap.org/data/2.5/"
        let requirementSchemeAttributes =
        "%@?lat=%@&lon=%@&appid=%@&lang=%@&cnt=%@&mode=%@&units=%@"

        let args: [String] = [format.rawValue, "\(lat)", "\(lon)", apikey,
                              lang.rawValue, "\(cnt)", mode.rawValue, units.rawValue]
        let requirement = String(format: requirementScheme + requirementSchemeAttributes,
                                 arguments: args)

        // assert

        XCTAssertEqual(requirement, sut.urlString)
    }
}
