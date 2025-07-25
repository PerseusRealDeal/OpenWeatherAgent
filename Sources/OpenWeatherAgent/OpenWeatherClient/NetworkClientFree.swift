//
//  NetworkClientFree.swift
//  OpenWeatherAgent
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

public enum OpenWeatherAPIClientError: Error, Equatable {
    case invalidUrl
    case failedRequest(String)
    case statusCode404
    case failedResponse(String)
}

public class NetworkClientFree {

    #if DEBUG
    private(set) var dataTask: URLSessionDataTaskProtocol?
    var session: URLSessionProtocol!
    #else
    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession
    #endif

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
