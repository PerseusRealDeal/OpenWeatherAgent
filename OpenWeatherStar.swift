//
//  OpenWeatherStar.swift
//  Version: 0.1.0
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk.
//  All rights reserved.
//
//
//  MIT License
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
// swiftlint:disable closure_parameter_position
//

import Foundation

class OpenWeatherFreeClient: FreeNetworkClient {

    func call(with respect: OpenWeatherDetails) throws {
        guard let requestURL = URL(string: respect.urlString) else {
            throw NetworkClientError.invalidUrl
        }

        requestData(url: requestURL)
    }
}

enum NetworkClientError: Error, Equatable {
    case invalidUrl
    case failedRequest(String)
}

enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

class FreeNetworkClient {

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession

    var onDataGiven: (Result<Data, NetworkClientError>) -> Void = { _ in }

    var data: Data { return networkData }
    private(set) var networkData: Data = Data() {
        didSet {
            onDataGiven(.success(networkData))
        }
    }

    init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }

    internal func requestData(url: URL) {

        dataTask = session.dataTask(with: URLRequest(url: url)) {
            [self] (requestedData: Data?, response: URLResponse?, error: Error?) -> Void in

            // Read answer

            var answerData: Data?
            var answerError: String?

            if let error = error {
                answerError = error.localizedDescription
            } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                answerError = HTTPURLResponse.localizedString(
                    forStatusCode: response.statusCode)
            } else if let requestedData = requestedData {
                answerData = requestedData
            }

            // Communicate changes

            DispatchQueue.main.async {

                if let requestedData = answerData {
                    self.networkData = requestedData
                } else if let error = answerError {
                    self.onDataGiven(.failure(.failedRequest(error)))
                }

                self.dataTask = nil
            }
        }

        dataTask?.resume()
    }
}

let weatherSchemeBase = "https://api.openweathermap.org/data/2.5/"
let weatherSchemeAttributes = "%@?lat=%@&lon=%@&appid=%@"

enum OpenWeatherURLFormat: String {
    case currentWeather = "weather"
    case forecast = "forecast"
}

enum Units: String {
    case standard // By default.
    case metric
    case imperial
}

enum Mode: String {
    case json // By default.
    case xml
    case html
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
    let mode: Mode

    var cnt: Int = -1 // A number of timestamps, which will be returned in the API response.

    init(appid: String, format: OpenWeatherURLFormat = .currentWeather,
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

    var urlString: String {

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
