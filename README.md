# OpenWeatherFreeClient

> OpenWeatherMap API Wrapper.

[![Actions Status](https://github.com/perseusrealdeal/OpenWeatherFreeClient/actions/workflows/main.yml/badge.svg)](https://github.com/perseusrealdeal/OpenWeatherFreeClient/actions)
![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)
[![Pod](https://img.shields.io/badge/Pod-1.0.0-informational.svg)](/OpenWeatherFreeClient.podspec)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%209.3+_|_macOS%2010.9+-orange.svg)](https://en.wikipedia.org/wiki/IOS_9)
[![SDK UIKit](https://img.shields.io/badge/SDK-UIKit%20-blueviolet.svg)](https://developer.apple.com/documentation/uikit)
[![Xcode 10.1](https://img.shields.io/badge/Xcode-10.1+-red.svg)](https://en.wikipedia.org/wiki/Xcode)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.2-red.svg)](https://docs.swift.org/swift-book/RevisionHistory/RevisionHistory.html)
[![License](http://img.shields.io/:License-MIT-blue.svg)](/LICENSE)

## Integration Capabilities

[![Standalone File](https://img.shields.io/badge/Standalone%20File-available-informational.svg)](/OpenWeatherStar.swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods manager](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg)](https://cocoapods.org)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg)](https://github.com/apple/swift-package-manager)

# Requirements

- Xcode 10.1+
- Swift 4.2+
- iOS: 9.3+, UIKit SDK
- macOS: 10.9+, AppKit SDK

# Third-party software

- [SwiftLint](https://github.com/realm/SwiftLint) / [0.31.0: Busy Laundromat](https://github.com/realm/SwiftLint/releases/tag/0.31.0) for macOS High Sierra

# Installation

## Standalone 

Make a copy of the file [`OpenWeatherStar.swift`](/OpenWeatherStar.swift) then put it into a place required of a host project.

## CocoaPods

Podfile should contain:

```ruby
target "ProjectTarget" do
  use_frameworks!
  pod 'OpenWeatherFreeClient', '1.0.0'
end
```
## Carthage

Cartfile should contain:

```carthage
github "perseusrealdeal/OpenWeatherFreeClient" == 1.0.0
```

Some Carthage usage tips placed [here](https://gist.github.com/perseusrealdeal/8951b10f4330325df6347aaaa79d3cf2).

## Swift Package Manager

- As a package dependency so Package.swift should contain the following statements:

```swift
dependencies: [
        .package(url: "https://github.com/perseusrealdeal/OpenWeatherFreeClient.git",
            .exact("1.0.0"))
    ],
```

- As an Xcode project dependency: 

`Project in the Navigator > Package Dependencies > Add Package Dependency`

Using "Exact" with the Version field is strongly recommended.

# License MIT

All files from this repository is under license based on MIT.

Copyright © 7530 - 7531 Mikhail Zhigulin of Novosibirsk.

- The year starts from the creation of the world according to a Slavic calendar.
- September, the 1st of Slavic year.

Have a look at [LICENSE](/LICENSE) for details.

# Author

`OpenWeatherFreeClient` was written at Novosibirsk by Mikhail Zhigulin i.e. me, mzhigulin@gmail.com.
