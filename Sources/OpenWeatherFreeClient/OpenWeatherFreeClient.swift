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
