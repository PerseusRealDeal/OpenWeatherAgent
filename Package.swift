// swift-tools-version:5.7

/* Package.swift
 Version: 0.3.5

 Created by Mikhail Zhigulin in 7531.

 Copyright © 7531 - 7533 Mikhail A. Zhigulin of Novosibirsk
 Copyright © 7533 PerseusRealDeal

 Licensed under the MIT license. See LICENSE file.
 All rights reserved.

 Abstract:
 Package manifest for the OpenWeather Agent.
*/

import PackageDescription

let package = Package(
    name: "OpenWeatherAgent",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "OpenWeatherAgent",
            targets: ["OpenWeatherAgent"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "OpenWeatherAgent",
            dependencies: []),
        .testTarget(
            name: "OpenWeatherAgentTests",
            dependencies: ["OpenWeatherAgent"])
    ]
)
