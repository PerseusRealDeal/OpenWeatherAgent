//
//  OpenWeatherRequestDetails.swift
//  OpenWeatherFreeClient
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

import Foundation

public let weatherSchemeBase = "https://api.openweathermap.org/data/2.5/"
public let weatherSchemeAttributes = "%@?lat=%@&lon=%@&appid=%@"

public enum OpenWeatherURLFormat: String {
    case currentWeather = "weather" // Default.
    case forecast = "forecast"
}

public enum Units: String {
    case standard // Default.
    case metric
    case imperial
}

public enum Mode: String {
    case json // Default.
    case xml
    case html
}

public struct Lang: RawRepresentable {
    public var rawValue: String
    public static let byDefault = Lang(rawValue: "")

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Lang {
    public static let en = Lang(rawValue: "en")
    public static let ru = Lang(rawValue: "ru")
}

public struct OpenWeatherDetails {

    public let appid: String
    public let format: OpenWeatherURLFormat

    public let lat: String
    public let lon: String

    public let units: Units
    public let lang: Lang
    public let mode: Mode

    // A number of timestamps, which will be returned in the API response.
    public var cnt: Int = -1

    public init(appid: String, format: OpenWeatherURLFormat = .currentWeather,
                lat: String = "55.66", lon: String = "85.62", units: Units = .standard,
                lang: Lang = Lang.byDefault, mode: Mode = Mode.json) {

        self.appid = appid
        self.format = format
        self.lat = lat
        self.lon = lon
        self.units = units
        self.lang = lang
        self.mode = mode
    }

    public var urlString: String {

        let args: [String] = [format.rawValue, lat, lon, appid]
        var attributes = String(format: weatherSchemeAttributes, arguments: args)

        if !lang.rawValue.isEmpty {
            attributes.append("&lang=\(lang.rawValue)")
        }

        if format == .forecast && cnt != -1 {
            attributes.append("&cnt=\(cnt)")
        }

        if mode != .json {
            attributes.append("&mode=\(mode.rawValue)")
        }

        if units != .standard {
            attributes.append("&units=\(units.rawValue)")
        }

        return weatherSchemeBase + attributes
    }
}
