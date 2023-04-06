//
//  PerseusLogger.swift
//  PerseusRealDeal
//
//  Created by Mikhail Zhigulin in 7531.
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk.
//  Copyright © 7531 PerseusRealDeal.
//  All rights reserved.
//
//
//  MIT License
//
//  Copyright © 7531 Mikhail Zhigulin of Novosibirsk
//  Copyright © 7531 PerseusRealDeal
//
//  The year starts from the creation of the world according to a Slavic calendar.
//  September, the 1st of Slavic year.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notices and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

class PerseusLogger {

    enum Status {
        case on
        case off
    }

    enum Level: Int, CustomStringConvertible {

        var description: String {
            switch self {
            case .info:
                return "INFO"
            case .debug:
                return "DEBUG"
            case .error:
                return "ERROR"
            }
        }

        case info  = 3
        case debug = 2 // Default.
        case error = 1
    }

    #if DEBUG
    static var turned = Status.on
    #else
    static var turned = Status.off
    #endif

    static var level = Level.debug
    static var short = true

    static func message(_ text: @autoclosure () -> String,
                        _ type: Level = .debug,
                        _ file: StaticString = #file,
                        _ line: UInt = #line) {
        guard turned == .on, type.rawValue <= level.rawValue else { return }
        if short {
            print("\(type.description): \(text())")
        } else {
            let fileName = (file.description as NSString).lastPathComponent
            print("\(type.description): \(text()), file: \(fileName), line: \(line)")
        }
    }
}
