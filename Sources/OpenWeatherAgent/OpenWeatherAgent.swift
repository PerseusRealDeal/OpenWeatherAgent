//
//  OpenWeatherAgent.swift
//  OpenWeatherAgent
//
//  Created by Mikhail Zhigulin in 7533.
//
//  Copyright © 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

import Foundation

@available(macOS 10.15.0, *)
@available(iOS 13.0.0, *)
public class OpenWeatherAgent {

    // MARK: - Properties

    public static var shared: OpenWeatherAgent { instance }

    // MARK: - Contract

    public func fetch(with respect: OpenWeatherRequestData) async throws -> Data {
        do {
            guard let url = URL(string: respect.urlString) else {
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
    private init() { }
}
