//
//  OpenWeatherFreeClient.swift
//  OpenWeatherFreeClient
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk.
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

import Foundation

let weatherSchemeBase = "https://api.openweathermap.org/data/2.5/"
let weatherSchemeAttributes = "%@?lat=%@&lon=%@&units=%@&appid=%@"

enum OpenWeatherURLFormat: String {
    case currentWeather = "weather"
    case forecast = "forecast"
}

enum Units: String {
    case standard = "standard" // By default.
    case metric = "metric"
    case imperial = "imperial"
}

struct Lang: RawRepresentable {
    var rawValue: String
    static let byDefault = Lang(rawValue: "") // By default lang attribute is empty.
}

extension Lang {
    static let en = Lang(rawValue: "en")
    static let ru = Lang(rawValue: "ru")
}

struct OpenWeatherDetails {

    let appid: String
    let format: OpenWeatherURLFormat

    let lat: String
    let lon: String

    let units: Units
    let lang: Lang

    var cnt: Int = -1 // A number of timestamps, which will be returned in the API response.

    init(appid: String, format: OpenWeatherURLFormat = .currentWeather,
         lat: String = "55.66", lon: String = "85.62",
         units: Units = .standard, lang: Lang = Lang.ru) {

        self.appid = appid
        self.format = format
        self.lat = lat
        self.lon = lon
        self.units = units
        self.lang = lang
    }

    var urlString: String {

        let args: [String] = [format.rawValue, lat, lon, units.rawValue, appid]
        var attributes = String(format: weatherSchemeAttributes, arguments: args)

        if !lang.rawValue.isEmpty {
            attributes.append("&lang=\(lang.rawValue)")
        }

        if format == .forecast && cnt != -1 {
            attributes.append("&cnt=\(cnt)")
        }

        return weatherSchemeBase + attributes
    }
}

enum OpenWeatherCallError: Error {
    case failedRequest(String)
}

class OpenWeatherFreeClient {

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession?

    var requestError: OpenWeatherCallError?

    var onDataGiven: (Data) -> Void = { print($0 as Any) }
    var data: Data { return weatherData }

    private(set) var weatherData: Data = Data() {
        didSet {
            onDataGiven(weatherData)
        }
    }

    func call(with respect: OpenWeatherDetails) {
        weatherData = Data()
        print(respect.urlString)
        // guard let _ = dataTask, let _ = session else { return }
    }
}
