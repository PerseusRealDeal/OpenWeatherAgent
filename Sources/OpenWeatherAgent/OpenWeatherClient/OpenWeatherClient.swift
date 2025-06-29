//
//  OpenWeatherClient.swift
//  OpenWeatherClient
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

public class OpenWeatherClient: NetworkClientFree {

    public func call(with respect: OpenWeatherRequestData) throws {
        guard let requestURL = URL(string: respect.urlString) else {
            // WRONG: URL cann't be created at all
            throw OpenWeatherAPIClientError.invalidUrl
        }

        requestData(url: requestURL)
    }
}
