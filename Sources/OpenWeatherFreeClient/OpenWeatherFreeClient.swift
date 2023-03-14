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

enum OpenWeatherCallError: Error {
    case failedRequest(String)
}

struct OpenWeatherCallDetails {
    var appID: String!
    var version: String!
}

class OpenWeatherFreeClient {

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession?

    var requestError: OpenWeatherCallError?

    var onDataGiven: (Data) -> Void = { print($0 as Any) }
    var forecast: Data { return forecastData }

    private(set) var forecastData: Data = Data() {
        didSet {
            onDataGiven(forecastData)
        }
    }

    func call(with respect: OpenWeatherCallDetails) {
        forecastData = Data()
        // guard let _ = dataTask, let _ = session else { return }
    }
}
