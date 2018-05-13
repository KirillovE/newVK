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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.title = "Дом"
        annotation.subtitle = "Я здесь"
        annotation.coordinate = CLLocationCoordinate2DMake(55, 51)
        mapView.addAnnotation(annotation)
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
