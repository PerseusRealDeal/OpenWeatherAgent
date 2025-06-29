# OpenWeatherAgent — Xcode 14.2+

> [`Weather-MenuBar-App for macOS`](https://github.com/perseusrealdeal/TheDarkMoon)<br/>

> `OpenWeatherAgent` is an OpenWeatherMap API Client for`<https://api.openweathermap.org/data/2.5/>`.<br/>
> `Individual API key` is required.<br/>

> - To request current weather.<br/>
> - To request `5 Day / 3 Hour` forecast.<br/>

> `OpenWeatherAgent` is a single author and personale solution developed in `person-to-person` relationship paradigm.

[![Actions Status](https://github.com/perseusrealdeal/OpenWeatherAgent/actions/workflows/main.yml/badge.svg)](https://github.com/perseusrealdeal/OpenWeatherAgent/actions/workflows/main.yml)
[![Style](https://github.com/perseusrealdeal/OpenWeatherAgent/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/perseusrealdeal/OpenWeatherAgent/actions/workflows/swiftlint.yml)
[![Version](https://img.shields.io/badge/Version-0.3.3-green.svg)](/CHANGELOG.md)
[![Platforms](https://img.shields.io/badge/Platforms-macOS%2010.13+Cocoa_|_iOS%2011.0+UIKit-orange.svg)](https://en.wikipedia.org/wiki/List_of_Apple_products)
[![Xcode 14.2](https://img.shields.io/badge/Xcode-14.2+-red.svg)](https://en.wikipedia.org/wiki/Xcode)
[![Swift 5.7](https://img.shields.io/badge/Swift-5.7-red.svg)](https://www.swift.org)
[![License](http://img.shields.io/:License-MIT-blue.svg)](/LICENSE)

## Integration Capabilities

[![Standalone](https://img.shields.io/badge/Standalone-available-informational.svg)](/OpenWeatherStar.swift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg)](/Package.swift)

> Use Stars to adopt [`OpenWeatherAgent`](/OpenWeatherStar.swift) for the specifics you need.

## Dependencies

[![ConsolePerseusLogger](http://img.shields.io/:ConsolePerseusLogger-1.5.0-green.svg)](https://github.com/perseusrealdeal/ConsolePerseusLogger.git)

# Approbation Matrix

<!-- [`A3 Environment and Approbation`](/APPROBATION.md) / [`CHANGELOG`](/CHANGELOG.md) for details. -->

> [`CHANGELOG`](/CHANGELOG.md) for details.

# In brief > Idea to use, the Why

> There're so many things happen unexpectedly... and weather is the most one.

# Build system requirements

- [macOS Monterey 12.7.6+](https://apps.apple.com/by/app/macos-monterey/id1576738294) / [Xcode 14.2+](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_14.2/Xcode_14.2.xip)

> But as the single source code file [OpenWeatherStar.swift](/OpenWeatherStar.swift) PDM can be used even in Xcode 10.1.

# First-party software

| Type | Name                                                                                                                                                                  | License |
| ---- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| Star | [ConsolePerseusLogger](https://github.com/perseusrealdeal/ConsolePerseusLogger) / [1.5.0](https://github.com/perseusrealdeal/ConsolePerseusLogger/releases/tag/1.5.0) | MIT     |

# Third-party software

| Type   | Name                                                                                                                              | License                            |
| ------ | --------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| Style  | [SwiftLint](https://github.com/realm/SwiftLint) / [v0.57.0 for Monterey+](https://github.com/realm/SwiftLint/releases/tag/0.57.0) | MIT                                |
| Script | [SwiftLint Shell Script](/SucceedsPostAction.sh) to run SwiftLint                                                                 | MIT                                |
| Action | [mxcl/xcodebuild@v3](https://github.com/mxcl/xcodebuild)                                                                          | [Unlicense](https://unlicense.org) |
| Action | [cirruslabs/swiftlint-action@v1](https://github.com/cirruslabs/swiftlint-action/)                                                 | MIT                                |

# Installation

> Standalone: the single source code file [OpenWeatherStar.swift](/OpenWeatherStar.swift)

> Swift Package Manager: `https://github.com/perseusrealdeal/OpenWeatherAgent`

# Usage

## Request Current Weather

### `Case structured concurrency:` closure completion callbacks

```swift

// Source Code: prettyPrinted
// https://gist.github.com/perseusrealdeal/945c9050cb9f7a19e00853f064acacca

let apikey = "The API key"

let client = OpenWeatherClient()
let respect = OpenWeatherRequestData(appid: apikey)

client.onDataGiven = { result in

    switch result {
    case .success(let weatherData):
        log.message(weatherData.prettyPrinted! as String)
    case .failure(let error):
        var errStr = ""
        switch error {
        case .failedRequest(let errText):
            errStr = errText
        case .failedResponse(let errText):
            errStr = errText
        case .invalidUrl:
            errStr = "invalidUrl"
        case .statusCode404:
            errStr = "statusCode404"
        }
        log.message("[OpenWeatherAgent]\(#function): \(errStr)", .error)
    }
}

try? client.call(with: respect)

```

### `Case async-await concurrency:` only from iOS 13, macOS 10.15

``` swift

// Source Code: prettyPrinted
// https://gist.github.com/perseusrealdeal/945c9050cb9f7a19e00853f064acacca

let apikey = "The API key"
let respect = OpenWeatherRequestData(appid: apikey)

do {
    let data = try await OpenWeatherAgent.shared.fetch(with: respect)
    log.message(data.prettyPrinted! as String)
} catch let error as OpenWeatherAPIClientError {
    log.message("OpenWeatherAPIClientError: \(error)", .error)
} catch {
    log.message(error.localizedDescription, .error)
}

```

## Request Forecast 

### `Case structured concurrency:` closure completion callbacks

```swift

// Source Code: prettyPrinted
// https://gist.github.com/perseusrealdeal/945c9050cb9f7a19e00853f064acacca

let apikey = "The API key"

let client = OpenWeatherClient()
let respect = OpenWeatherRequestData(appid: apikey, format: .forecast)

client.onDataGiven = { result in

    switch result {
    case .success(let weatherData):
        log.message(weatherData.prettyPrinted! as String)
    case .failure(let error):
        var errStr = ""
        switch error {
        case .failedRequest(let errText):
            errStr = errText
        case .failedResponse(let errText):
            errStr = errText
        case .invalidUrl:
            errStr = "invalidUrl"
        case .statusCode404:
            errStr = "statusCode404"
        }
        log.message("[OpenWeatherAgent]\(#function): \(errStr)", .error)
    }
}

try? client.call(with: respect)

```

### `Case async-await concurrency:` only from iOS 13, macOS 10.15

``` swift

// Source Code: prettyPrinted
// https://gist.github.com/perseusrealdeal/945c9050cb9f7a19e00853f064acacca

let apikey = "The API key"
let respect = OpenWeatherRequestData(appid: apikey, format: .forecast)

do {
    let data = try await OpenWeatherAgent.shared.fetch(with: respect)
    log.message(data.prettyPrinted! as String)
} catch let error as OpenWeatherAPIClientError {
    log.message("OpenWeatherAPIClientError: \(error)", .error)
} catch {
    log.message(error.localizedDescription, .error)
}

```

# Points taken into account

- Preconfigured Swift Package manifest [Package.swift](/Package.swift)
- Preconfigured SwiftLint config [.swiftlint.yml](/.swiftlint.yml)
- Preconfigured SwiftLint CI [swiftlint.yml](/.github/workflows/swiftlint.yml)
- Preconfigured GitHub config [.gitignore](/.gitignore)
- Preconfigured GitHub CI [main.yml](/.github/workflows/main.yml)

# License MIT

Copyright © 7530 - 7533 Mikhail A. Zhigulin of Novosibirsk<br/>
Copyright © 7533 PerseusRealDeal

- The year starts from the creation of the world according to a Slavic calendar.
- September, the 1st of Slavic year. It means that "Sep 01, 2024" is the beginning of 7533.

## Other Required License Notices

© 2025 The SwiftLint Contributors **for** SwiftLint</br>
© GitHub **for** GitHub Action cirruslabs/swiftlint-action@v1</br>
© 2021 Alexandre Colucci, geteimy.com **for** Shell Script SucceedsPostAction.sh</br>

[LICENSE](/LICENSE) for details.

## Credits

<table>
<tr>
    <td>Balance and Control</td>
    <td>kept by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Source Code</td>
    <td>written by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Documentation</td>
    <td>prepared by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
<tr>
    <td>Product Approbation</td>
    <td>tested by</td>
    <td>Mikhail A. Zhigulin</td>
</tr>
</table>

- Language support: [Reverso](https://www.reverso.net/)
- Git clients: [SmartGit](https://syntevo.com/) and [GitHub Desktop](https://github.com/apps/desktop)

# Author

> © Mikhail A. Zhigulin of Novosibirsk.
