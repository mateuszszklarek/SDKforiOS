# IndoorwayKit

[![Twitter](https://img.shields.io/badge/twitter-@Indoorway-blue.svg?style=flat)](http://twitter.com/indoorway)

Indoorway lets you find your way indoors. Check it out!

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
	- **Configuration** 
		- [Initial configuration](#initial-configuration)
		- [Visitor configuration](#visitor-configuration)
	- **Maps**
		- [Map displaying](#map-displaying)
		- [Custom map rendering](#custom-map-rendering)
		- [Custom map annotations](#custom-map-annotations)
		- [Indoor objects selection](#indoor-objects-selection)
		- [Tap detection](#tap-detection)
		- [Indoor objects list](#indoor-objects-list)
		- [Navigation](#navigation)
	- **Location**
		- [Indoor location manager](#indoor-location-manager)
		- [Location ranging](#location-ranging) 
	- **Model**
		- [Buildings information manager](#buildings-information-manager)
		- [Points of interest types manager](#points-of-interest-types-manager)
		- [Events tracking](#events-tracking)
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

## Requirements

IndoorwayKit framework is implemented in Swift and requires system version:

- iOS 10.0+

If you are using Swift:

- Xcode 8.1+
- Swift 3.0.1+

If you are using Objective-C:

- Xcode 7.3.1+

Location module requires Bluetoooth turned on to obtain location data.

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
    pod 'IndoorwayKit', '~> 1.1.0'
end
```

And then, run bash command in your project's folder:

```bash
$ pod install
```

## Usage

### Initial configuration

Before any use of the framework you must configure it by using your API key. The best place to apply configuration is your Application Delegete `application(_:didFinishLaunchingWithOptions:)` method:

```swift
import IndoorwayKit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	
	IndoorwayConfiguration.configure(withApiKey: "<Your API key>")
	
	return true
}
```

### Visitor configuration

Current user registration is optional. It is only required to aggregate locations, send tracking events and gather information for statistical purposes. 

```swift
IndoorwayConfiguration.setupVisitor(withName: "John Appleseed", age: 30, sex: .male, group: "Engineers")
```

If user name or group is not applicable, pass empty strings.
If age of the user is also not applicable, pass negative value.

### Map displaying

To display map, use `IndoorwayMapView` object and load map by using it's building UUID and map UUID:

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

It is recommended to implement a map view's delegate protocol and set it as delegate in the map view to receive callbacks, like information that map has finished launching, which can be used to retry if it fails:

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

For more information check other methods in protocol `IndoorwayMapViewDelegate`.

### Custom map rendering

To customize displaying attributes of map view simply implement protocol `IndoorwayMapRendererConfiguration`:

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
		super.init()
	}
}
```

and add the following annotation to the map view:

```swift
let annotation = ExampleAnnotation(
	coordinate: IndoorwayLatLon(latitude: latitude, longitude: longitude)
)
mapView.addAnnotation(annotation)
```

Annotations can be removed as shown in the following example:

```swift
mapView.removeAnnotation(annotation)
```

Annotations have a default view, but you can customize them by implementing `IndoorwayMapViewDelegate` method as presented below:

```swift
enum ExampleMapViewIdentifiers: String {
	case exampleAnnotation = "example.annotation.view.identifier.example"
	case userLocationAnnotation = "example.annotation.view.identifier.userlocation"
}

func mapView(_ mapView: IndoorwayMapView, viewForAnnotation annotation: IndoorwayAnnotation) -> IndoorwayAnnotationView? {
	var view: IndoorwayAnnotationView? = nil

	// Example annotation
	if let annotation = annotation as? ExampleAnnotation {
		// Reused annotation view
		if let reusedView = dequeueReusableAnnotationView(withIdentifier: ExampleMapViewIdentifiers.exampleAnnotation.rawValue) {
			reusedView.annotation = annotation
			view = reusedView
		}
		// New annotation view
		else {
			let newView = IndoorwayAnnotationView(annotation: annotation, reuseIdentifier: ExampleMapViewIdentifiers.exampleAnnotation.rawValue)
			newView.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
			newView.backgroundColor = UIColor.red
			newView.layer.cornerRadius = view.bounds.height/2.0
			view = newView
		}
	}

	// User location view
	else if let annotation = annotation as? IndoorwayUserLocation {
		// Reused annotation view
		if let reusedView = dequeueReusableAnnotationView(withIdentifier: ExampleMapViewIdentifiers.userLocationAnnotation.rawValue) {
			reusedView.annotation = annotation
			view = reusedView
		}
		// New annotation view
		else {
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

`IndoorwayMapViewDelegate` has also methods that will be called when user did selects or deselects annotation view:

```swift
func mapView(_ mapView: IndoorwayMapView, didSelectAnnotationView view: IndoorwayAnnotationView) {
	print("User did select annotation view \(view.description)")
}
func mapView(_ mapView: IndoorwayMapView, didDeselectAnnotationView view: IndoorwayAnnotationView) {
	print("User did deselect annotation view  \(view.description)")
}
```

### Indoor objects selection

When user selects or deselects indoor objects, the following methods from the map view's delegate are called:

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

When user tap's location is not associated with annotation or indoor object, the following method from the map view's delegate will be called:

```swift
func mapView(_ mapView: IndoorwayMapView, didTapLocation location: IndoorwayLatLon) {
	print("User did tap location: \(location.latitude) \(location.longitude)")
}
```

### Indoor objects list

You can access the list of indoor objects on the loaded map using `indoorObjects` property of `IndoorwayMapView` object:

```swift
mapView.indoorObjects
```

To search for indoor objects that contain specific tag:

```swift
let tag = "Sample tag"
let objectsWithTag = mapView.indoorObjects
	.filter {
		$0.objectTags.contains(tag)
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

- navigate from current user's location to specific indoor object with identifier

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

#### Path points

You can access the list of navigation path points on the loaded map using `pathPoints` property of `IndoorwayMapView` object:

```swift
mapView.pathPoints
```

### Indoor location manager

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

The framework allows you to define custom ranges. When user enters or exits defined region, `IndoorwayLocationManagerDelegate` provides callbacks for these actions:

```swift
func locationManager(_ manager: IndoorwayLocationManager, didEnter region: IndoorwayRegion) {
	let enterData: IndoorwayRegionData? = region.notifications
		.flatMap {
			if case .enter(let data) = $0 { return data }
			else { return nil }
		}.first
	guard let data = enterData else { return }
	print("Entered: \(data.title) with description: \(data.description)")
}

func locationManager(_ manager: IndoorwayLocationManager, didExit region: IndoorwayRegion) {
	let exitData: IndoorwayRegionData? = region.notifications
		.flatMap {
			if case .exit(let data) = $0 { return data }
			else { return nil }
		}.first
	guard let data = exitData else { return }
	print("Exit: \(data.title) with description: \(data.description)")
}
```

You can access notification data in region model `region.notifications`. It contains enter or exit notification with associated data. Example of obtaining enter notification data: 

```swift
let enterData: IndoorwayRegionData? = region.notifications
	.flatMap {
		if case .enter(let data) = $0 { return data }
		else { return nil }
	}.first
```

#### Remote defined ranges

You can specify remotely ranges to be monitored in the Indooway Dashboard. It would appear in the application automatically. You just need to handle callbacks from the delegate.

#### Locally defined ranges

To create range in code create an object that inherits from `IndoorwayRegion`. The framework provides a predefined circular region `IndoorwayCircularRegion` and notifications for two types of actions. As an example you can create custom range that fits your implementation needs.

First create notification that holds all data that you will receive when user enters specific region:

```swift
let enter = IndoorwayRegionNotification.exit(
	IndoorwayRegionData(
		title: "Hey!",
		description: "Look at right!",
		timeout: 1.0,
		imageURL: URL(string: "https://look.at/me"),
		actionURL: URL(string: "https://open.me/link")
	)
)
```

Next create, for example, a circular region specifying unique identifier, center location and radius in meters:

```swift
let circularRegion = IndoorwayCircularRegion(
	identifier: "Example unique identifier",
	center: IndoorwayLocation(
		latitude: 10.0000, // Example latitude
		longitude: 20.000, // Example longitude
		uncertainty: nil,
		buildingUUID: "The building UUID",	// Example building UUID
		mapUUID: "The map UUID"				// Example map UUID
	),
	radius: 20.000, // Radius in meters
	notifications: [enter]
)
```

Next pass it to the `IndoorwayLocationManager` instance for start ranging method: 

```swift
locationRanger.startRanging(circularRegion)
```

To stop ranging call:

```swift
locationRanger.stopRanging(circularRegion)
```

### Buildings information manager

To fetch building base information with associated maps use `IndoorwayBuildingsManager` class. First create building manager object:

```swift
let buildingManager = IndoorwayBuildingsManager()
```

and call the following method:

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

and call the following method:

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

### Events tracking

The framework provides event tracking tool. You can access it from the shared instance of `IndoorwayTrackingManager`. First create `IndoorwayEvent`instance as an event that you want to track and pass it as an argument to `track(_:)` method:

```swift
IndoorwayTrackingManager.shared.track(
	IndoorwayEvent(
		uuid: "Example unique identifier",
		category: "Example category",
		label: "Example label",
		interaction: "Example interaction"
	)
)
```

For example, to track remote defined ranging events as a `uuid`, pass an range `identifier`.

## Submission

This framework uses custom cryptography. When submitting your app to the AppStore that uses the framework, you must answer each of the export compliance questions:
- *Is your app designed to use cryptography or does it contain or incorporate cryptography?* - **YES**
- *Does your app meet any of the following? [...]*  - **YES**
- *Does your app implement any encryption algorithms that are proprietary or yet-to-be-accepted as standards by international standard bodies (IEEE, IETF, ITU, and so on)?* - **Up to your implementation**
- *Does your app implement any standard encryption algorithms instead of, or in addition to, using or accessing the encryption in Apple’s iOS or macOS?* - **YES**
- *Are you releasing your app in France?* - **Up to your distribution**

## Support

Any suggestions or reports of technical issues are welcome! Contact us via email contact@indoorway.com.

## Licence

IndoorwayKit is available under the custom license. See the LICENSE file for more info.
