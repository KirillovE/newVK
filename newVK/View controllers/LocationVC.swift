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

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func moveToMyLocation(_ sender: UIBarButtonItem) {
    }
}

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

extension LocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            let currentRadius: CLLocationDistance = 1_000
            let currentRegion = MKCoordinateRegionMakeWithDistance(currentLocation, currentRadius * 2, currentRadius * 2)
            mapView.setRegion(currentRegion, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
}
