# IndoorwayKit

[![Twitter](https://img.shields.io/badge/twitter-@Indoorway-blue.svg?style=flat)](http://twitter.com/indoorway)

Indoorway lets you find your way indoors. Check it out!

## Features

- [x] Indoor location
- [x] Navigation
- [x] Map view
	- [x] Customizable colors, size and fonts
	- [x] Possibility to add view annotations
	- [x] MapKit like interface

## Requirements

IndoorwayKit framework is implemented in Swift and requires system version:

- iOS 10.0+

If you are using Swift:

- Xcode 8.1+
- Swift 3.1+

If you are using Objective-C:

- Xcode 7.3.1+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. To build IndoorwayKit, CocoaPods in version 1.0.0+ is required. You can easily install it from Ruby gem by using the following bash command:

```bash
$ gem install cocoapods
```


You can integrate IndoorwayKit to your Xcode project using CocoaPods `Podfile` like:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'IndoorwayKit', '~> 1.4.4'
end
```

And then, run bash command in your project's folder:

```bash
$ pod install
```
## Support

Any suggestions or reports of technical issues are welcome! Contact us via email contact@indoorway.com.

## Licence

IndoorwayKit is available under the custom license. See the LICENSE file for more info.

## Documentation

You can read full documentation on [Indoorway Developer Guide](https://docs.indoorway.com/ios/requirements/index.html).
