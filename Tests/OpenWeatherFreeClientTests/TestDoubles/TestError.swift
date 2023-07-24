//
//  TestError.swift
//  OpenWeatherFreeClientTests
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk.
//
//  Licensed under the MIT license. See LICENSE file.
//  All rights reserved.
//

import Foundation

struct TestError: LocalizedError {
    let message: String?
    var errorDescription: String? { return message }
}
