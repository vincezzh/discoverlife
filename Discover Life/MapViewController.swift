//
//  ViewController.swift
//  Discover Life
//
//  Created by Zhehan Zhang on 2015-07-08.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var previousSearchLocation: CLLocation?
    var previousLocation: CLLocation?
    var previousHeading: Double = 0.0
    var radius: Double = 1000
    var placeType = "coffee"
    var search: AppleSearch = AppleSearch()
    var hasNotLocation: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let currentLocation: CLLocation = locations[0] as! CLLocation
//        println("currentLocation: \(currentLocation)")
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)) {
            let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: false)
            self.mapView.showsUserLocation = true
        }else {
            mapView.showsBuildings = true
            mapView.showsUserLocation = true
            mapView.mapType = MKMapType.Standard
            
            if self.previousLocation == nil {
                self.previousLocation = currentLocation
            }else {
                let camera: MKMapCamera = MKMapCamera(lookingAtCenterCoordinate: currentLocation.coordinate, fromEyeCoordinate: self.previousLocation!.coordinate, eyeAltitude: 200.0)
                camera.pitch = 75.0
                camera.heading = currentLocation.course
                mapView.setCamera(camera, animated: false)
            }
        }
        
        self.searchKeywords(currentLocation)
    }
    
    func searchKeywords(currentLocation: CLLocation) {
        if self.previousSearchLocation != nil {
            let distance = currentLocation.distanceFromLocation(previousSearchLocation)
            if distance as Double > (radius / 2) {
                previousSearchLocation = currentLocation
                search.refreshMapInformation(self.mapView, location: currentLocation, placeType: placeType, radius: radius)
            }
        }else {
            previousSearchLocation = currentLocation
            search.refreshMapInformation(self.mapView, location: currentLocation, placeType: placeType, radius: radius)
        }
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "pin"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
        }else {
            anView.annotation = annotation
        }
        
        let cpa = annotation as! CustomPointAnnotation
        anView.image = cpa.iconImage
        
        return anView
    }


}

