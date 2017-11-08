//
//  Created by Indoorway on 08.11.2017.
//  Copyright © 2017 Indoorway. All rights reserved.
//

import UIKit
import IndoorwaySdk

class MapViewController: UIViewController {

    private let mapView = IndoorwayMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        
        loadMap()
        IndoorwayLocationSdk.instance().position.onChange.addListener(listener: self)
    }

    private func setupMapView() {
        view.addSubview(mapView)

        setupMapViewConstraints()
    }

    private func setupMapViewConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false

        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func loadMap() {
        let mapDescription = IndoorwayMapDescription(buildingUuid: <#buildingUuid#>, mapUuid: <#mapUuid#>)
        mapView.loadMap(with: mapDescription) { [weak self] _ in
            self?.mapView.showsUserLocation = true
        }
    }

}

extension MapViewController: IndoorwayPositionListener {

    func positionChanged(position: IndoorwayLocation) {
        print("\(position.longitude), \(position.latitude) ")
    }

}
