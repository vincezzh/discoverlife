//
//  GoogleSearch.swift
//  Discover Life
//
//  Created by Vince Zhang on 2015-07-10.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import MapKit

class GoogleSearch {
    
    var googleAPIKey = "AIzaSyA-nRmE_wa1BJm4PV0agBfpAC0K4xjEz_s"
    
    func refreshMapInformation(mapView: MKMapView, location: CLLocation, placeType: String, radius: Double) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let urlPath = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&types=\(placeType)&key=\(googleAPIKey)"
        let url = NSURL(string: urlPath)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {
            (data, response, error) -> Void in
            
            if error == nil {
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                let returnedPlaces: NSArray? = jsonResult["results"] as? NSArray
                if returnedPlaces != nil && returnedPlaces?.count > 0 {
                    var index = 0
                    for returnedPlace in returnedPlaces! {
                        var placeLatitude: Double = 0
                        var placeLongitude: Double = 0
                        var placeName = ""
                        var iconPath = ""
                        
                        if let name = returnedPlace["name"] as? NSString {
                            placeName = name as String
                        }
                        
                        if let icon = returnedPlace["icon"] as? NSString {
                            iconPath = icon as String
                        }
                        
                        if let geometry = returnedPlace["geometry"] as? NSDictionary {
                            if let location = geometry["location"] as? NSDictionary {
                                if let lat = location["lat"] as? Double {
                                    placeLatitude = lat
                                }
                                
                                if let lng = location["lng"] as? Double {
                                    placeLongitude = lng
                                }
                            }
                        }
                        
                        if placeLatitude != 0 && placeLongitude != 0 && placeName != "" && iconPath != "" {
                            let url = NSURL(string: iconPath)
                            let urlRequest = NSURLRequest(URL: url!)
                            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                                if error == nil {
                                    println(placeName)
                                    
                                    let location = CLLocationCoordinate2D(latitude: placeLatitude as CLLocationDegrees, longitude: placeLongitude as CLLocationDegrees)
                                    var pin = CustomPointAnnotation()
                                    pin.coordinate = location
                                    pin.title = placeName
                                    pin.iconImage = UIImage(data: data, scale: 5)
                                    mapView.addAnnotation(pin)
                                }
                            })
                        }
                    }
                }
            }else {
                println(error)
            }
        })
        
        task.resume()
    }
    
}