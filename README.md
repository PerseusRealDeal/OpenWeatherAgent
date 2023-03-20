# OpenWeatherFreeClient

> OpenWeatherMap Free API Client.

[![Actions Status](https://github.com/perseusrealdeal/OpenWeatherFreeClient/actions/workflows/main.yml/badge.svg)](https://github.com/perseusrealdeal/OpenWeatherFreeClient/actions)
![Version](https://img.shields.io/badge/Version-0.1.0-green.svg)
[![Pod](https://img.shields.io/badge/Pod-0.1.0-informational.svg)](/OpenWeatherFreeClient.podspec)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%209.3+_|_macOS%2010.9+-orange.svg)](https://en.wikipedia.org/wiki/IOS_9)
[![Xcode 10.1](https://img.shields.io/badge/Xcode-10.1+-red.svg)](https://en.wikipedia.org/wiki/Xcode)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-red.svg)](https://docs.swift.org/swift-book/RevisionHistory/RevisionHistory.html)
[![License](http://img.shields.io/:License-MIT-blue.svg)](/LICENSE)

## Integration Capabilities

[![Standalone](https://img.shields.io/badge/Standalone%20-available-informational.svg)](/OpenWeatherStar.swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods manager](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg)](https://cocoapods.org)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg)](https://github.com/apple/swift-package-manager)

# In Brief

> This library lets a developer make calls requesting data available for free with [OpenWeather API](https://openweathermap.org). It brings implementation of [`Current Weather Data`](https://openweathermap.org/current) and [`5 Day / 3 Hour Forecast`](https://openweathermap.org/forecast5) of the API.

# Requirements

- Xcode 10.1+
- Swift 4.2+
- iOS: 9.3+, UIKit SDK
- macOS: 10.9+, AppKit SDK

# Third-party software

- [SwiftLint](https://github.com/realm/SwiftLint) / [0.31.0: Busy Laundromat](https://github.com/realm/SwiftLint/releases/tag/0.31.0) for macOS High Sierra

# Usage

## Call Current Weather

```swift
let apikey = "The API key"

let client = OpenWeatherFreeClient()
let callDetails = OpenWeatherDetails(appid: apikey)

client.onDataGiven = { result in

  switch result {
    case .success(let weatherData):
      print("""
        DATA: BEGIN
        \(String(decoding: weatherData, as: UTF8.self))
        DATA: END
      """)
    case .failure(let error):
      switch error {
       case .failedRequest(let message):
         print(message)
       default:
         break
      }
    }
}

try? client.call(with: callDetails)
```

## Call 5 Day / 3 Hour Forecast

```swift
let apikey = "The API key"

let client = OpenWeatherFreeClient()
let callDetails = OpenWeatherDetails(appid: apikey, format: .forecast)

client.onDataGiven = { result in

  switch result {
    case .success(let weatherData):
      print("""
        DATA: BEGIN
        \(String(decoding: weatherData, as: UTF8.self))
        DATA: END
      """)
    case .failure(let error):
      switch error {
       case .failedRequest(let message):
         print(message)
       default:
         break
      }
    }
}

try? client.call(with: callDetails)
```

# Installation

## Standalone 

Make a copy of the file [`OpenWeatherStar.swift`](/OpenWeatherStar.swift) then put it into a place required of a host project.

## Carthage

Cartfile should contain:

```carthage
github "perseusrealdeal/OpenWeatherFreeClient" == 0.1.0
```

Some Carthage usage tips placed [here](https://gist.github.com/perseusrealdeal/8951b10f4330325df6347aaaa79d3cf2).

## CocoaPods

Podfile should contain:

```ruby
target "ProjectTarget" do
  use_frameworks!
  pod 'OpenWeatherFreeClient', '0.1.0'
end
```

## Swift Package Manager

- As a package dependency so Package.swift should contain the following statements:

```swift
dependencies: [
        .package(url: "https://github.com/perseusrealdeal/OpenWeatherFreeClient.git",
            .exact("0.1.0"))
    ],
```

- As an Xcode project dependency: 

`Project in the Navigator > Package Dependencies > Add Package Dependency`

Using "Exact" with the Version field is strongly recommended.

# License MIT

All files from this repository is under license based on MIT.

Copyright © 7531 Mikhail Zhigulin of Novosibirsk.

- The year starts from the creation of the world according to a Slavic calendar.
- September, the 1st of Slavic year.

Have a look at [LICENSE](/LICENSE) for details.

# Author

> `OpenWeatherFreeClient` was written at Novosibirsk by Mikhail Zhigulin i.e. me, mzhigulin@gmail.com.
