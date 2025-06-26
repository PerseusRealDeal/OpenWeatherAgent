//
//  TestError.swift
//  OpenWeatherAgentTests
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

struct TestError: LocalizedError {
    let message: String?
    var errorDescription: String? { return message }
}
