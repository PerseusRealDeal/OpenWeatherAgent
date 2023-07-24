//
//  Protocols.swift
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

extension URLSession: URLSessionProtocol {

    #if os(macOS)
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler)
                as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    #else // iOS, tvOS, watchOS
    public func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request, completionHandler: completionHandler)
                as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    #endif
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

public protocol URLSessionProtocol {
    #if os(macOS) // macOS
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
    #else // iOS, tvOS, watchOS
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol
    #endif
}

public protocol URLSessionDataTaskProtocol {
    func resume()
}
