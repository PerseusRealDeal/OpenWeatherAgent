//
//  TestHelpers.swift
//  OpenWeatherFreeClientTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
//  Copyright © 7533 PerseusRealDeal
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

import XCTest
@testable import OpenWeatherFreeClient

class DummyURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {
        log.message("[\(type(of: self))].\(#function)")
    }
}

class MockURLSession: URLSessionProtocol {

    // for network request testing
    var dataTaskCallCount: Int = 0
    var dataTaskArgsRequest: [URLRequest] = []

    // for network response testing
    var dataTaskArgsCompletionHandler: [(Data?, URLResponse?, Error?) -> Void] = []

    #if os(macOS)
    func dataTask(with request: URLRequest, completionHandler: @escaping
        (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {

        appendRequest(request: request)
        dataTaskArgsCompletionHandler.append(completionHandler)

        // return self.session.dataTask(with: request)
        return DummyURLSessionDataTask()
        // return session.dataTask(with: URLRequest(url: URL(string: "http://DUMMY")!))
    }
    #else
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable
        (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {

        appendRequest(request: request)
        dataTaskArgsCompletionHandler.append(completionHandler)

        // return self.session.dataTask(with: request)
        return DummyURLSessionDataTask()
        // return session.dataTask(with: URLRequest(url: URL(string: "http://DUMMY")!))
    }
    #endif

    private func appendRequest(request: URLRequest) {
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)
    }

    // MARK: - Verifier methods

    internal func verifyDataTask(with request: URLRequest,
                                 file: StaticString = #file,
                                 line: UInt = #line) {
        guard dataTaskWasCalledOnce(file: file, line: line) else { return }
        XCTAssertEqual(dataTaskArgsRequest.first, request, "request", file: file, line: line)
    }

    private func dataTaskWasCalledOnce(file: StaticString = #file,
                                       line: UInt = #line) -> Bool {
        return verifyMethodCalledOnce(methodName: "dataTask(with:completionHandler:)",
                                      callCount: dataTaskCallCount,
                                      describeArguments: "request: \(dataTaskArgsRequest)",
            file: file,
            line: line)
    }
}

private func verifyMethodCalledOnce(methodName: String,
                                    callCount: Int,
                                    describeArguments: @autoclosure () -> String,
                                    file: StaticString = #file,
                                    line: UInt = #line) -> Bool {
    if callCount == 0 {
        XCTFail("Wanted but not invoked: \(methodName)", file: file, line: line)
        return false
    }

    if callCount > 1 {
        XCTFail("Wanted 1 time but was called \(callCount) times. " +
            "\(methodName) with \(describeArguments())", file: file, line: line)
        return false
    }

    return true
}

internal func loadTestJsonData() -> Data {
    guard let data = currentWeatherTestData.data(using: .utf8) else { return Data() }
    return data
}

internal func response(statusCode: Int) -> HTTPURLResponse? {
    return HTTPURLResponse(url: URL(string: "http://DUMMY")!,
                           statusCode: statusCode,
                           httpVersion: nil,
                           headerFields: nil)
}
