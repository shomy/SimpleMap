//
//  ViewController.swift
//  SimpleMap
//
//  Created by Masaaki Uno on 2016/12/30.
//  Copyright © 2016年 Masaaki Uno. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    var locationManager : CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tapStartButton(_ sender: UIButton) {
        if locationManager != nil { return }
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.startUpdatingLocation()
        }
        // tracking user location
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        mapView.showsUserLocation = true

    }
    @IBAction func tapStopButton(_ sender: UIButton) {
        guard let manager = locationManager else { return }
        manager.stopUpdatingLocation()
        manager.delegate = nil
        locationManager = nil
        latLabel.text = "latitude: "
        lngLabel.text = "longitude: "
        
        // untracking user location
        mapView.userTrackingMode = MKUserTrackingMode.none
        mapView.showsUserLocation = false
        mapView.removeAnnotations(mapView.annotations)

    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let location:CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        let latitude = "".appendingFormat("%.4f", location.latitude)
        let longitude = "".appendingFormat("%.4f", location.longitude)
        latLabel.text = "latitude: " + latitude
        lngLabel.text = "longitude: " + longitude
        
        // update annotation
        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        
        // Showing annotation zooms the map automatically.
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }

}

