//
//  CamaraViewController.swift
//  Discover Life
//
//  Created by Vince Zhang on 2015-07-10.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import UIKit
import MapKit

class CamaraViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var trueHeading = 180.0
    var firstLocation: CLLocation?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        println("\(newHeading.trueHeading)")
//        mapView.camera.heading = newHeading.trueHeading
//        mapView.setCamera(camera, animated: false)
        
//        let camera: MKMapCamera = MKMapCamera()
//        camera.pitch = 75.0
//        camera.heading = newHeading.trueHeading
//        camera.altitude = 10.0
//        mapView.setCamera(camera, animated: false)
        
        self.trueHeading = newHeading.trueHeading
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let currentLocation: CLLocation = locations[0] as! CLLocation
//        let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
//        let region = MKCoordinateRegion(center: location, span: span)
//        self.mapView.setRegion(region, animated: false)
//        self.mapView.showsUserLocation = true
//        mapView.camera.heading = trueHeading
        
        if self.firstLocation == nil {
            self.firstLocation = currentLocation
        }else {
            let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: currentLocation.coordinate, fromEyeCoordinate: self.firstLocation!.coordinate, eyeAltitude: 200.0)
            camera.pitch = 75.0
            camera.heading = currentLocation.course
            mapView.setCamera(camera, animated: false)
        }
    }
    
    /* Set up the map and add it to our view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.Standard
//        mapView.userTrackingMode = .Follow
        
//        let camera: MKMapCamera = MKMapCamera()
//        camera.pitch = 75.0
//        camera.heading = 0.0
//        camera.altitude = 10.0
//        mapView.showsBuildings = true
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .Follow
//        mapView.setCamera(camera, animated: false)
    }
    
}
