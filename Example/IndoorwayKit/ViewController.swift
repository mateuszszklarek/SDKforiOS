//
//  ViewController.swift
//  IndoorwayKit
//
//  Created by Indoorway on 11/14/2016.
//  Copyright (c) 2016 Indoorway. All rights reserved.
//

import UIKit
import IndoorwayKit

class ViewController: UIViewController {
	
	// MARK: Indoorway map view
	
	private var mapView: IndoorwayMapView!
	
	private func insertMapView() {
		
		// Add map view
		view.addSubview(mapView)
		
		// Add constraints
		layoutMapView()
	}
	
	// MARK: Indoorway location manager
	
	var locationManager: IndoorwayLocationManager!
	
	// MARK: View controller life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Create and instert map view
		mapView = IndoorwayMapView()
		mapView.delegate = self
		insertMapView()
	
		// Create location manager
		locationManager = IndoorwayLocationManager()
		locationManager.delegate = self
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Start location updates
		locationManager.startLocationUpdates()
		
		// Map description
		let mapDescription = IndoorwayMapDescription(
			buildingUUID: <#T##NSString#>,
			mapUUID: <#T##NSString#>
		)
		
		// Loading map
		mapView.loadMap(with: mapDescription) { [weak self] (success) in
			guard let `self` = self else { return }
			self.mapView.showsUserLocation = true
		}
	}
	
	private func layoutMapView() {
		mapView.translatesAutoresizingMaskIntoConstraints = false
		
		func createConstraint(withAttribute attribute: NSLayoutAttribute) -> NSLayoutConstraint {
			 return NSLayoutConstraint(
				item: mapView,
				attribute: attribute,
				relatedBy: .equal,
				toItem: view,
				attribute: attribute,
				multiplier: 1.0,
				constant: 0
			)
		}
		
		view.addConstraints([.left, .right, .top, .bottom].map {
			createConstraint(withAttribute: $0)
		})
	}
}

extension ViewController: IndoorwayLocationManagerDelegate {

	func locationManager(_ manager: IndoorwayLocationManager, didFailWithError error: Error) {
		print("Location manager did fail with error \(error.localizedDescription)")
	}
	
    func locationManager(_ manager: IndoorwayLocationManager, didUpdateLocation location: IndoorwayLocation) {
		print("Location manager did update location: (latitude:\(location.latitude), longitude:\(location.longitude))")
	}
	
    func locationManager(_ manager: IndoorwayLocationManager, didUpdateHeading heading: IndoorwayHeading) {
		print("Loation manager did update heading: \(heading)")
	}
	
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
		print("Exited: \(data.title) with description: \(data.description)")
	}
}

extension ViewController: IndoorwayMapViewDelegate {
	
	// Map loading
	
    func mapViewDidFinishLoadingMap(_ mapView: IndoorwayMapView) {
		print("Map view did finish loading")
	}
    
	func mapViewDidFailLoadingMap(_ mapView: IndoorwayMapView, withError error: Error) {
		print("Map view did fail loading map with error: \(error.localizedDescription)")
	}
	
	// Location
	
    func mapView(_ mapView: IndoorwayMapView, didUpdate userLocation: IndoorwayUserLocation) {
		print("Map view did update user location: (latitude:\(userLocation.coordinate.latitude), longitude:\(userLocation.coordinate.longitude)")
	}
	
	// Actions
    
	func mapView(_ mapView: IndoorwayMapView, didSelectIndoorObject indoorObjectInfo: IndoorwayObjectInfo) {
		print("User did select indoor object with identifier: \(indoorObjectInfo.objectId)")
	}
    
	func mapView(_ mapView: IndoorwayMapView, didTapLocation location: IndoorwayLatLon) {
		print("User did tap location: \(location.latitude) \(location.longitude)")
	}

}
