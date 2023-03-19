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

class OpenWeatherFreeClient: FreeNetworkClient {

    func call(with respect: OpenWeatherDetails) throws {
        guard let requestURL = URL(string: respect.urlString) else {
            throw NetworkClientError.invalidUrl
        }

        requestData(url: requestURL)
    }
}
