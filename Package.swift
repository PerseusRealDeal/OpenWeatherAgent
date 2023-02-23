// swift-tools-version:4.2

/* Package.swift
 Version: 0.0.1

 Created by Mikhail Zhigulin in 7531.

 Copyright © 7531 Mikhail Zhigulin of Novosibirsk.

 Licensed under the MIT license. See LICENSE file.
 All rights reserved.

 Abstract:
 Package manifest for an App component.
*/

import PackageDescription

let package = Package(
    name: "XcodeTemplateProject",
    products: [
        .library(
            name: "XcodeTemplateProject",
            targets: ["XcodeTemplateProject"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "XcodeTemplateProject",
            dependencies: []),
        .testTarget(
            name: "XcodeTemplateProjectTests",
            dependencies: ["XcodeTemplateProject"])
    ]
)
