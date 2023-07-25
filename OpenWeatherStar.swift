//
//  OpenWeatherStar.swift
//  Version: 0.1.1
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
// swiftlint:disable file_length closure_parameter_position
//

import Foundation

public class OpenWeatherFreeClient: FreeNetworkClient {

    public func call(with respect: OpenWeatherDetails) throws {
        guard let requestURL = URL(string: respect.urlString) else {
            throw NetworkClientError.invalidUrl
        }

        requestData(url: requestURL)
    }
}

public enum NetworkClientError: Error, Equatable {
    case invalidUrl
    case failedRequest(String)
    case statusCode404
    case failedResponse(String)
}

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

public class FreeNetworkClient {

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession

    public var onDataGiven: (Result<Data, NetworkClientError>) -> Void = { result in
        switch result {
        case .success(let weatherData):
            print("""
            — Default closure invoked! \(#function): \(result)
              DATA: BEGIN
              \(String(decoding: weatherData, as: UTF8.self))
              DATA: END
            """)
        case .failure(let error):
            switch error {
            case .failedRequest(let message):
                log.message(message, .error)
            default:
                break
            }
        }
    }

    public var data: Data { return networkData }
    private(set) var networkData: Data = Data() {
        didSet {
            onDataGiven(.success(networkData))
        }
    }

    public init(_ session: URLSession = URLSession.shared) {
        self.session = session
    }

    internal func requestData(url: URL) {

        log.message("[\(type(of: self))].\(#function)")

        dataTask = session.dataTask(with: URLRequest(url: url)) {
            [self] (requestedData: Data?, response: URLResponse?, error: Error?) -> Void in

            // Answer

            var answerData: Data?
            var answerError: NetworkClientError?

            // Check Status

            if let error = error {
                answerError = .failedResponse(error.localizedDescription)
                // WRONG: https://apiiiii.openweathermap.org/...
            } else {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 404 {
                        answerError = .statusCode404
                        // WRONG: https://api.openweathermap.org/data/999/...
                    } else if statusCode != 200 {
                        answerError = .failedResponse(
                            HTTPURLResponse.localizedString(forStatusCode: statusCode))
                        // WRONG: https://api.openweathermap.org/...&appid=wrong_api_key
                    }
                } else {
                    answerError = .failedResponse("No Status Code")
                }
            }

            // Data

            answerData = requestedData ?? Data()

            // Communicate Changes

            if let error = answerError {
                self.onDataGiven(.failure(error))
            } else if let data = answerData {
                self.networkData = data
            }

            self.dataTask = nil
        }

        dataTask?.resume()
    }
}

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
