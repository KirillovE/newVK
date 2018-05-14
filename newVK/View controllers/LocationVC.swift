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
    var coordinates = CLLocation()
    var currentAddress = ""
    let regionDiameter = 2_000.0
    let addLocationButton = UIButton(type: .contactAdd)
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        addLocationButton.addTarget(self, action: #selector(addLocationPressed), for: .touchUpInside)
    }

    @IBAction func moveToMe(_ sender: UIButton) {
        mapView.setCenter(currentPlace, animated: true)
        let currentRegion = MKCoordinateRegionMakeWithDistance(currentPlace, regionDiameter, regionDiameter)
        mapView.setRegion(currentRegion, animated: true)
    }
    
    @objc func addLocationPressed() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(currentAddress, forKey: "address")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        annotationView.leftCalloutAccessoryView = addLocationButton
        annotationView.annotation = annotation
        return annotationView
    }
    
}

// MARK: - Getting current location

extension LocationVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            currentPlace = currentLocation
            getAddress()
            
            let currentRegion = MKCoordinateRegionMakeWithDistance(currentLocation, regionDiameter, regionDiameter)
            mapView.setRegion(currentRegion, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
    func getAddress() {
        coordinates = CLLocation(latitude: currentPlace.latitude, longitude: currentPlace.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(coordinates) { [weak self] myPlaces, _ in
            if let place = myPlaces?.last {
                let country = place.country ?? ""
                let city = place.locality ?? ""
                let street = place.thoroughfare ?? ""
                self?.currentAddress = "\n\(country), \(city), \(street)"
                print(self?.currentAddress ?? "no address")
            }
        }
    }
    
}
