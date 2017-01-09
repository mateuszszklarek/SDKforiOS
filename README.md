# IndoorwayKit

[![Twitter](https://img.shields.io/badge/twitter-@Indoorway-blue.svg?style=flat)](http://twitter.com/indoorway)

Indoorway lets you find your way indoors. Check it out!

- [Features](#features)
- [Requirements](#reqiurements)
- [Installation](#instalation)
- [Usage](#usage)
	- **Configuration -** [Initial confguration](#initial-configuration), [Visitor configuration](#visitor-configuration)
	- **Maps -** [Map displaying](#map-displaying), [Custom map rendering](#custom-map-rendering), [Custom map annotations](#custom-map-annotations), [Indoor objects selection](#indoor-objects-selection), [Tap detection](#tap-detection), [Navigation](#navigation)
	- **Navigation -** [Navigation](#navigation)
	- **Location -** [Indoor location manager](#indoor-location-manager). [Location ranging](#location-ranging)
	- **Model -** [Buildings informations manager](#buildings-informations-manager), [Points of interest types manager](#points-of-interest-types-manager), [Indoor objects](#indoor-objects)
- [Documentation](#documentation)
- [Submission](#submission)
- [Support](#support)
- [Licence](#licence)

## Features

- [x] Indoor location
- [x] Navigation
- [x] Map view
	- [x] Customizable colors, size and fonts
	- [x] Possibility to add view annotations
	- [x] MapKit like interface
- [x] Documentation

## Requirements

IndoorwayKit framework is implemented in Swift and requires system version:

- iOS 10.1+

If you are using Swift:

- Xcode 8.1+	
- Swift 3.0.1+

If you are using Objective-C:

- Xcode 7.0+

Location module requires Bluetoooth turned on to obtain location data.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. To build IndoorwayKit, CocoaPods in version 1.0.0+ is required. You can easily install it from Ruby gem using following bash command:

```bash
$ gem install cocoapods
```


You can integrate IndoorwayKit to your Xcode project using CocoaPods `Podfile` like:

```ruby
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.1'
use_frameworks!

target '<Your Target Name>' do
	pod 'HanekeSwift', :git => 'https://github.com/Haneke/HanekeSwift.git', :branch => 'feature/swift-3'
    pod 'IndoorwayKit', '~> 1.0.0'
end
```

And then, run bash command in your project folder:

```bash
$ pod install
```

## Usage

### Initial confguration

Before any use of the framework you must configure it using your API key. The best place to apply configuration is your Application Delegete `application(_:didFinishLaunchingWithOptions:)` method:

```swift
import IndoorwayKit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	
	IndoorwayConfiguration.configure(withApiKey: "<Your API key>")
	
	return true
}
```

### Visitor configuration

Current user registration is optional, but required to aggregate locations, and gather informations for statistical purpouses. 

```swift
IndoorwayConfiguration.setupVisitor(withName: "John Appleseed", age: 30, sex: .male, group: "Engineers")
```

If user name or group is not applicable pass empty strings.
If age of the user is also not applicable pass negative value.

### Map displaying

To display map, use `IndoorwayMapView` object and load map using it's building UUID and map UUID:

```swift
import IndoorwayKit

var mapView = IndoorwayMapView()

let description = IndoorwayMapDescription(
	buildingUUID: "<building UUID>",
	mapUUID: "<map UUID>"
)

mapView.loadMap(with: description) { [weak self] (completed) in
	self?.mapView.showsUserLocation = completed // To start displaying location if map is properly loaded
}
```

It is recomended to implement a map view's delegate protocol and set it as delegate in the map view to receive callbacks, like information that map did finish launching, which can be used to retry if it fails:

```swift
mapView.delegate = self
```

```swift
extension ViewController: IndoorwayMapViewDelegate {
	
	// Map loading
	func mapViewDidFinishLoadingMap(_ mapView: IndoorwayMapView) {
		print("Map view did finish loading")
	}
	func mapViewDidFailLoadingMap(_ mapView: IndoorwayMapView, withError error: Error) {
		print("Map view did fail loading map with error: \(error.localizedDescription)")
	}
	// And many other methods
}
```

For more informations check the rest of the methods in protocol `IndoorwayMapViewDelegate`.

### Custom map rendering

To customize map view's displaying attributes simply implement protocol `IndoorwayMapRendererConfiguration`:

```swift
import IndoorwayKit

class ExampleMapRenderingCongiguration: IndoorwayMapRendererConfiguration {
	
	struct MapRendererColors {
		static let background = UIColor.white.cgColor
		static let outline = UIColor.black.cgColor
		static let room = UIColor.gray.cgColor
		static let toilet = UIColor.orange.cgColor
		static let stairs = UIColor.darkGray.cgColor
		static let inaccessible = UIColor.black.cgColor
		static let unknown = UIColor.black.cgColor
		static let selected = UIColor.blue.cgColor
		static let text = UIColor.white.cgColor
	}
	
	struct MapRendererSizes {
		static let objectStrokeWidth = 2.0
		static let outlineStrokeWidth = 4.0
		static let textSize = 12.0
	}
	
	func backgroundColor() -> CGColor {
		return MapRendererColors.background
	}
	
	func strokeWidth(forObject object: IndoorwayObjectInfo) -> CGFloat {
		return MapRendererSizes.objectStrokeWidth
	}
	
	func outlineFillColor() -> CGColor? {
		return MapRendererColors.outline
	}
	
	func outlineStrokeWidth() -> CGFloat {
		return MapRendererSizes.outlineStrokeWidth
	}
	
	func outlineStrokeColor() -> CGColor? {
		return MapRendererColors.outline
	}
	
	func strokeColor(forObject object: IndoorwayObjectInfo) -> CGColor? {
		if object.objectType != IndoorwayObjectType.path {
			return MapRendererColors.outline
		}
		return nil
	}
	
	func fillColor(forObject object: IndoorwayObjectInfo) -> CGColor? {
		switch (object.objectType, object.name) {
		case (.toilet, _):
			return MapRendererColors.toilet
		case (.room, _):
			return MapRendererColors.room
		case (.stairs, _):
			return MapRendererColors.stairs
		case (.inaccessible, _):
			return MapRendererColors.inaccessible
		case (.unknown, _):
			return MapRendererColors.unknown
		default:
			return MapRendererColors.unknown
		}
	}
	
	func textColor() -> CGColor {
		return MapRendererColors.text
	}
	
	func textStrokeColor() -> CGColor{
		return MapRendererColors.text
	}
	
	func textSize() -> CGFloat {
		return MapRendererSizes.textSize
	}
	
	var selectedObjectFillColor: CGColor? {
		return MapRendererColors.selected
	}
	
	var selectedObjectStrokeColor: CGColor? {
		return MapRendererColors.selected
	}
}
```

and apply it to the map view which you want to customize:

```swift
// Hold strong reference to object
let renderingConfiguration = ExampleMapRenderingCongiguration() 

// Set custom rendering configuration
mapView.renderingConfiguration = renderingConfiguration

```

### Custom map annotations

Map view supports custom annotations. To add annotation implement class conforming to `IndoorwayAnnotation` protocol:

```swift
class ExampleAnnotation: NSObject, IndoorwayAnnotation {
	var coordinate: IndoorwayLatLon
	var title: String?
	var subtitle: String?

	init(coordinate: IndoorwayLatLon) {
		self.coordinate = coordinate
	}
}
```

and add annotation described like that to map view:

```swift
let annotation = ExampleAnnotation(coordinate: IndoorwayLatLon(latitude: latitude, longitude: longitude))
mapView.addAnnotation(annotation)
```

Annotations can be removed like in following example:

```swift
mapView.removeAnnotation(annotation)
```

Annotations has a default view, but you can customize it by implementing `IndoorwayMapViewDelegate` method like:

```swift
enum ExampleMapViewIdentifiers: String {
	case exampleAnnotation = "example.annotation.view.identifier.example"
	case userLocationAnnotation = "example.annotation.view.identifier.userlocation"
}

func mapView(_ mapView: IndoorwayMapView, viewForAnnotation annotation: IndoorwayAnnotation) -> IndoorwayAnnotationView? {
	var view: IndoorwayAnnotationView = nil
	if let annotation = annotation as? ExampleAnnotation {
		if let reusedView = dequeueReusableAnnotationView(withIdentifier: ExampleMapViewIdentifiers.exampleAnnotation.rawValue) {
			view = reusedView
		} else {
			let newView = IndoorwayAnnotationView(annotation: annotation, reuseIdentifier: ExampleMapViewIdentifiers.exampleAnnotation.rawValue)
			newView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
			newView.backgroundColor = UIColor.red
			newView.layer.cornerRadius = view.bounds.height/2.0
			view = newView
		}
	}
	else if let annotation = annotation as? IndoorwayUserLocation {
		if let reusedView = dequeueReusableAnnotationView(withIdentifier: ExampleMapViewIdentifiers.userLocationAnnotation.rawValue) {
			view = reusedView
		} else {
			let newView = IndoorwayAnnotationView(annotation: annotation, reuseIdentifier: ExampleMapViewIdentifiers.userLocationAnnotation.rawValue)
			newView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
			newView.backgroundColor = UIColor.blue
			newView.layer.cornerRadius = view.bounds.height/2.0
			view = newView
		}
	}
	return view
}
```

`IndoorwayMapViewDelegate` has also methods that will be called when user did select or deselect annotation view:

```swift
func mapView(_ mapView: IndoorwayMapView, didSelectAnnotationView view: IndoorwayAnnotationView) {
	print("User did select annotation view \(view.description)")
}
func mapView(_ mapView: IndoorwayMapView, didDeselectAnnotationView view: IndoorwayAnnotationView) {
	print("User did deselect annotation view  \(view.description)")
}
```

### Indoor objects selection

When user selects or deselects indoor objects following methods from the map view's delegate are called:

```swift
func mapView(_ mapView: IndoorwayMapView, didSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) {
	print("User did select indoor object with identifier: \(indoorObjectInfo.objectId)")
}
func mapView(_ mapView: IndoorwayMapView, didDeselectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) {
	print("User did deselect indoor object with identifier: \(indoorObjectInfo.objectId)")
}
```

You can also specify which of indoor objects can be selected:

```swift
func mapView(_ mapView: IndoorwayMapView, shouldSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) -> Bool {
	print("Should user select indoorway object with this \(indoorObjectInfo.objectId) identifier or type \(indoorObjectInfo.objectType)?")
	return true
}
```

Indoor objects can be also selected programmatically by identifier:

```swift
mapView.selectObject(withIndoorwayObjectId: "<indoor object identifier>")
```

or `IndoorwayObjectInfo`:

```swift
mapView.selectObject(withIndoorwayObject: objectInfo)
```

### Tap detection

When user tap's location is not associated with annotation or indoor object following method from the map view's delegate will be called:

```swift
func mapView(_ mapView: IndoorwayMapView, didTapLocation location: IndoorwayLatLon) {
	print("User did tap location: \(location.latitude) \(location.longitude)")
}
```

### Navigation

There are several ways you can display navigation in map view:

- navigate from current user's location to specific destination location

```swift
mapView.navigate(to: location)
```

- navigate from specific start location to specific destination location

```swift
mapView.navigate(form: startLocation, to: destinationLocation)
```

- navigate from current user's location to specific indoor object eith identifier

```swift
mapView.navigate(toObjectWithId: "<destination indoor object identifier>")
```

- navigate from specific indoor object with identifier to specific destination indoor object with identifier

```swift
mapView.navigate(fromObjectWithId: "<start indoor object identifier>", toObjectWithId: "<destination indoor object identifier>")
```

- navigate from current user's location to specific indoor object

```swift
mapView.navigate(to: indoorObject)
```

- navigate from specific indoor object to specific destination indoor object

```swift
mapView.navigate(from: startObject, to: destinationObject)
```

To stop displaying navigation call: 

```swift
mapView.stopNavigation()
```

### Indoor location manager

> To succesfully obtain location data previously load specific map in `IndoorwayMapView`

Indoor location manager is a source of information of user's location. To create manager and set it delegate: 

```swift
var locationManager = IndoorwayLocationManager()
locationManager.delegate = self
```

start location updates:

```swift
locationManager.startLocationUpdates()
```

and conform to location manager delegate's protocol `IndoorwayLocationManagerDelegate`:

```swift
func indoorwayLocationManager(_ manager: IndoorwayLocationManager, didFailWithError error: Error) {
	print("Location manager did fail with error \(error.localizedDescription)")
}
func indoorwayLocationManager(_ manager: IndoorwayLocationManager, didUpdateLocation location: IndoorwayLocation) {
	print("Location manager did update location: (latitude:\(location.latitude), longitude:\(location.longitude))")
}
func indoorwayLocationManager(_ manager: IndoorwayLocationManager, didUpdateHeading heading: IndoorwayHeading) {
	print("Loation manager did update heading: \(heading)")
}
```

To stop location updates: 

```swift
locationManager.stopLocationUpdates()
```

### Location ranging

Framework allows you to set special range using location and radius to get callbacks when user enters or leaves specified area. For acomplish this functionality create location ranger and set enter and leave closure:

```swift
let locationRanger = IndoorwayLocationRanger(rangedLocation: location, rangingDistance: distance)

locationRanger.enterClosure {
	print("User entered range")
}

locationRanger.leaveClosure {
	print("User leave range")
}
```

To start ranging call:

```swift
locationRanger.startRanging()
```

To stop ranging call:

```swift
locationRanger.stopRanging()
```

### Buildings informations manager

To fetch building base informations with associated maps use `IndoorwayBuildingsManager` class. First create building manager object:

```swift
let buildingManager = IndoorwayBuildingsManager()
```

and call following method:

```swift
buildingManager.getBuildings { (buildings, error) in
	if let error = error {
		print("Error occured while obtaining buildings \(error.localizedDescription)")
	} else if let buildings = buildings {
		print("Buildings obtained:")
		dump(buildings)
	}
}
```

### Points of interest types manager

To fetch points of interest types use `IndoorwayPointsOfInterestTypesManager` class. First create points of interest types manager object:

```swift
let poiTypesManager = IndoorwayPointsOfInterestTypesManager()
```

and call following method:

```swift
poiTypeManager.getPointsOfInterestTypes { (poiTypes, error) in
	if let error = error {
		print("Error occured while obtaining POI types \(error.localizedDescription)")
	} else if let poiTypes = poiTypes {
		print("POI types obtained:")
		dump(poiTypes)
	}
}
```

### Indoor objects

You can list indoor objects on the loaded map using `indoorObjects` property of `IndoorwayMapView` object:

```swift
mapView.indoorObjects
```

## Documentation

Full documentation will be available soon.  

> If you need more informations contact us at contact@indoorway.com.

## Submission

This framework uses custom cryptography. When submmiting your app to the AppStore that uses the framework you must answer each of the export compliance questions:
- *Is your app designed to use cryptography or does it contain or incorporate cryptography?* - **YES**
- *Does your app meet any of the following? [...]*  - **YES**
- *Does your app implement any encryption algorithms that are proprietary or yet-to-be-accepted as standards by international standard bodies (IEEE, IETF, ITU, and so on)?* - **Up to your implementation**
- *Does your app implement any standard encryption algorithms instead of, or in addition to, using or accessing the encryption in Apple’s iOS or macOS?* - **YES**
- *Are you releasing your app in France?* - **Up to your distribution**


## Support

If you want to contact us please send email at contact@indoorway.com. Any suggestions or reports of technical issues are welcome!

## License

IndoorwayKit is available under the custom license. See the LICENSE file for more info.
