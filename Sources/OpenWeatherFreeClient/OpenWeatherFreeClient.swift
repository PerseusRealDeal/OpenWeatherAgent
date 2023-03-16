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
    func call(with respect: OpenWeatherDetails) {
        requestData(url: URL(string: respect.urlString)!)
    }
}

class FreeNetworkClient {

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession?

    var requestError: OpenWeatherCallError?

    var onDataGiven: (Data) -> Void = { print($0 as Any) }
    var data: Data { return networkData }

    private(set) var networkData: Data = Data() {
        didSet {
            onDataGiven(networkData)
        }
    }

    internal func requestData(url: URL) {

        // guard let _ = dataTask, let _ = session else { return }

        networkData = Data()
        print(url.absoluteString)
    }
}
