//
//  OpenWeatherStar.swift
//  Version: 0.3.5
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  All rights reserved.
//
//
//  MIT License
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
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
// swiftlint:disable file_length
//

import Foundation

public class OpenWeatherClient: NetworkClientFree {

    public func call(with respect: OpenWeatherRequestData) throws {
        guard let requestURL = URL(string: respect.urlString) else {
            // WRONG: URL cann't be created at all
            throw OpenWeatherAPIClientError.invalidUrl
        }

        requestData(url: requestURL)
    }
}

public enum OpenWeatherAPIClientError: Error, Equatable {
    case invalidUrl
    case failedRequest(String)
    case statusCode404
    case failedResponse(String)
}

public class NetworkClientFree {

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession

    public var onDataGiven: (Result<Data, OpenWeatherAPIClientError>) -> Void = { result in
        switch result {
        case .success(let weatherData):
            log.message("[FreeNetworkClient].\(#function):\(result)")
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
            log.message("[FreeNetworkClient].\(#function): \(errStr)", .error)
        }
    }

    public var data: Data { return networkData }
    private(set) var networkData: Data = Data() {
        didSet {
            onDataGiven(.success(networkData))
        }
    }

    public init(_ session: URLSession = URLSession.shared) {
        log.message("[\(type(of: self))].\(#function)", .info)
        self.session = session
    }

    internal func requestData(url: URL) {
        dataTask = session.dataTask(with: URLRequest(url: url)) {
            // swiftlint:disable:next closure_parameter_position
            [self] (requestedData: Data?, response: URLResponse?, error: Error?) in

            // Answer

            var answerData: Data?
            var answerError: OpenWeatherAPIClientError?

            // Check Status

            if let error = error {
                // WRONG: https://apiiiii.openweathermap.org/...
                answerError = .failedResponse(error.localizedDescription)
            } else {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 404 {
                        // WRONG: https://api.openweathermap.org/data/999/...
                        answerError = .statusCode404
                    } else if !(200...299).contains(statusCode) {
                        // WRONG: https://api.openweathermap.org/...&appid=wrong_api_key
                        answerError = .failedResponse(
                            HTTPURLResponse.localizedString(forStatusCode: statusCode))
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

public enum OpenWeatherRequest: String {
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

public struct OpenWeatherRequestData {

    public let appid: String
    public let request: OpenWeatherRequest

    public let lat: String
    public let lon: String

    public let units: Units
    public let lang: Lang
    public let mode: Mode

    // A number of timestamps, which will be returned in the API response.
    public var cnt: Int = -1

    public init(appid: String,
                request: OpenWeatherRequest = .currentWeather,
                lat: String = "55.66",
                lon: String = "85.62",
                units: Units = .standard,
                lang: Lang = Lang.byDefault,
                mode: Mode = Mode.json) {

        self.appid = appid
        self.request = request
        self.lat = lat
        self.lon = lon
        self.units = units
        self.lang = lang
        self.mode = mode
    }

    public var urlString: String {

        let args: [String] = [request.rawValue, lat, lon, appid]
        var attributes = String(format: weatherSchemeAttributes, arguments: args)

        if !lang.rawValue.isEmpty {
            attributes.append("&lang=\(lang.rawValue)")
        }

        if request == .forecast && cnt != -1 {
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

@available(macOS 10.15.0, *)
@available(iOS 13.0.0, *)
public class OpenWeatherAgent {

    // MARK: - Properties

    public static var shared: OpenWeatherAgent { instance }

    // MARK: - Contract

    public func fetch(with respect: OpenWeatherRequestData) async throws -> Data {
        do {
            guard let url = URL(string: respect.urlString) else {
                // WRONG: URL cann't be created at all
                throw OpenWeatherAPIClientError.invalidUrl
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw OpenWeatherAPIClientError.failedResponse("Invalid Response")
            }

            guard (200...299).contains(statusCode) else {
                if statusCode == 404 {
                    // WRONG: https://api.openweathermap.org/data/999/...
                    throw OpenWeatherAPIClientError.statusCode404
                }
                // WRONG: https://api.openweathermap.org/...&appid=wrong_api_key
                let errorDetails = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                let details = "Status Code: \(statusCode), \(errorDetails)"
                throw OpenWeatherAPIClientError.failedResponse(details)
            }

            return data

        } catch let error as URLError {
            // WRONG: https://apiiiii.openweathermap.org/...
            throw OpenWeatherAPIClientError.failedRequest("URLError: \(error)")
        } catch {
            // WRONG: something else
            throw error
        }
    }

    // MARK: - Singletone

    private static var instance = OpenWeatherAgent()
    private init() {
        log.message("[\(type(of: self))].\(#function)", .info)
    }
}
