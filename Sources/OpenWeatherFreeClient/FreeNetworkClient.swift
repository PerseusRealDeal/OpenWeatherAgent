//
//  FreeNetworkClient.swift
//  OpenWeatherFreeClient
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk.
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//
// swiftlint:disable closure_parameter_position
//

import Foundation

public enum NetworkClientError: Error, Equatable {
    case invalidUrl
    case failedRequest(String)
}

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

class FreeNetworkClient {

    private(set) var dataTask: URLSessionDataTask?
    private(set) var session: URLSession

    var onDataGiven: (Result<Data, NetworkClientError>) -> Void = { result in
        #if DEBUG
        print(#function + ": \(result)")
        #endif
    }

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

            DispatchQueue.main.async { [weak self] in

                guard let self = self else { return }

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
