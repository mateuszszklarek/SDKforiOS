# IndoorwayKit change log

## `2.0.14`

### Changed

* Improved POI selection

## `2.0.13`

### Added

* Added visual representation for tapped POI

## `2.0.12`

### Changed

* Changed Swift version to 4.2

## `2.0.11`

### Fixed

* Fixed issue with not accesible annotations

## `2.0.10`

### Changed

* Updated navigation steps
* added centerPoint property in `IndoorwayObjectInfo`

## `2.0.9`

### Changed

* Updated listeners behaviour
* Added posibility to track navigation steps: call `getSteps()` on `IndoorwayMapView` while navigation is active
* Added possibility to track POI taps. `IndoorwayMapView` has new methods: `didSelectPOIObject` and `didDeselectPOIObject`

## `2.0.8`

###

### Changed

* Fixed issue with listeners


## `2.0.7`

###

### Changed

* Added possibility to set manually user's position

---
## `2.0.6`

###

### Changed

* Bump Swift version to 4.1

## `2.0.5`

### Improved

* Improved mechanism for log in and logout between multiple accounts

## `1.4.0`

#### Improved

* Added support for wider range of Beacon manufacturers
* Improvements in location algorithm
* Minor bug fixes

---

## `1.3.0`

#### Added

* Zoom map view to specific location
* Center map range defined by user location
* Possibility to rotate map using user heading
* Access to loaded map building and map name's
* QR code scanner view to improve sharing API key with co-workers
* Possibility to fetch visitors associated with your API key that allowed to share their location between other users
* Possibility to fetch last location update of visitors associated with your API key that allowed to share their location between other users

#### Improved

* New fields in visitor setup

---

## `1.2.1`

* Fixed bug that occurs in specific devices.

---

## `1.2.0`

#### Added

* Background location updates

#### Updated

* Map view renderer is way much faster
* Map view annotations displaying enhancements
    - Displaying annotation views by priority when zooming
    - Reduced overlaping
* Minor internal improvements

---

## `1.1.0`

#### Added

* Access to the navigation path points from loaded map
* Access to indoor objects with a list of tags
* Location ranging
    - locally defined regions
    - remote defined regions
    - custom notifications with associated data
* Event Tracker
    - possibility to track in app events
    - customizable up to implementation

#### Updated

* Changes in framework dependencies
* `IndoorwayLocationManagerDelegate`
    - methods refactoring
    - new methods for ranging
* `IndoorwayPOITypesManager`
    - renamed from IndoorwayPointsOfInterestITypesManager`
    - methods refactoring
    - type of completion handler result from get POIs method changed
* `IndoorwayBuildingsManager`
    - methods refactoring
    - type of completion handler result from get POIs method changed
