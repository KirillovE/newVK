//
//  LocationVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 13.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import MapKit
import CoreLocation

class LocationVC: UIViewController {

    // MARK: - Source data
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentPlace: CLLocationCoordinate2D!
    let regionDiameter = 2_000.0
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func moveToMyLocation(_ sender: UIBarButtonItem) {
        mapView.setCenter(currentPlace, animated: true)
        let currentRegion = MKCoordinateRegionMakeWithDistance(currentPlace, regionDiameter, regionDiameter)
        mapView.setRegion(currentRegion, animated: true)
    }
}

// MARK: - Showing annotation for pin

extension LocationVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "SomeIdentifier") as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        }
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "SomeIdentifier")
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        annotationView.annotation = annotation
        return annotationView
    }
    
}

// MARK: - Getting current location

extension LocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            currentPlace = currentLocation
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(locations.last!) { myPlaces, _ in
                if let place = myPlaces?.last {
                    print(place.country!)
                    print(place.locality!)
                    print(place.thoroughfare!)
                }
            }
            
            let currentRegion = MKCoordinateRegionMakeWithDistance(currentLocation, regionDiameter, regionDiameter)
            mapView.setRegion(currentRegion, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
}
