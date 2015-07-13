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

    @IBOutlet weak var mapNavigationItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var previousSearchLocation: CLLocation?
    var previousLocation: CLLocation?
    var previousHeading: Double = 0.0
    var radius: Double = 1000
    var placeType = "coffee"
    var search: AppleSearch = AppleSearch()
    var hasNotLocation: Bool = true
    var goToMapCenterPosition: Bool = true
    var displayMode = "2D";
    var selectedPlace: CustomPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        var gesture = UILongPressGestureRecognizer(target: self, action: "popupAnnotationSheetSelection:")
        gesture.minimumPressDuration = 1
        mapView.addGestureRecognizer(gesture)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        mapNavigationItem.title = placeType
        self.goToMapCenterPosition = true
    }
    
    @IBAction func back(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func settings(sender: AnyObject) {
        let settingsActionSheet = UIAlertController(title: "Settings", message: "Which mode do you prefer?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        settingsActionSheet.addAction(UIAlertAction(title: "2D", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
            self.displayMode = "2D"
            self.goToMapCenterPosition = true
        }))
        settingsActionSheet.addAction(UIAlertAction(title: "3D", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
            self.displayMode = "3D"
            self.goToMapCenterPosition = true
        }))
        settingsActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(settingsActionSheet, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let currentLocation: CLLocation = locations[0] as! CLLocation
//        println("currentLocation: \(currentLocation)")
        
        if displayMode == "2D" {
            if goToMapCenterPosition {
                if self.previousLocation == nil {
                    self.previousLocation = currentLocation
                }
                
                let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapView.setRegion(region, animated: false)
                self.mapView.showsUserLocation = true
                
                self.goToMapCenterPosition = false
            }
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

    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.searchKeywords(CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude))
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        self.selectedPlace = view.annotation as? CustomPointAnnotation
    }
    
    func popupAnnotationSheetSelection(gestureRecognizer: UIGestureRecognizer) {
        if self.selectedPlace != nil {
            let settingsActionSheet = UIAlertController(title: "Know More", message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            if self.selectedPlace!.url != nil {
                settingsActionSheet.addAction(UIAlertAction(title: "View Website", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
                    self.showPlaceWebsite()
                }))
            }
            if self.selectedPlace!.mapItem != nil {
                settingsActionSheet.addAction(UIAlertAction(title: "Direction", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) -> Void in
                    self.findDirections()
                }))
            }
            settingsActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(settingsActionSheet, animated: true, completion: nil)
        }
    }
    
    func findDirections() {
        var request: MKDirectionsRequest = MKDirectionsRequest()
        request.setSource(MKMapItem(placemark: MKPlacemark(coordinate: self.previousLocation!.coordinate, addressDictionary: nil)))
        request.setDestination(self.selectedPlace!.mapItem)
        request.transportType = MKDirectionsTransportType.Automobile
        let directions: MKDirections = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse!, error: NSError!) -> Void in
            if error == nil {
                let route: MKRoute = response.routes[0] as! MKRoute
                self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
            }
        }
    }
    
    func showPlaceWebsite() {
        performSegueWithIdentifier("showWebsite", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationViewController = segue.destinationViewController as! WebsiteViewController
        destinationViewController.placeName = self.selectedPlace!.name
        destinationViewController.url = self.selectedPlace!.url
    }
}

