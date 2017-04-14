# IndoorwayKit change log

#### 1.x Releases

- `1.1.x` Releases - [1.1.0](#110)
- `1.2.x` Releases - [1.2.0](#120)

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