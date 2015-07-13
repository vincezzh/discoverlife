//
//  AppleSearch.swift
//  Discover Life
//
//  Created by Vince Zhang on 2015-07-10.
//  Copyright (c) 2015 AkhalTech. All rights reserved.
//

import MapKit

class AppleSearch {
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    func refreshMapInformation(mapView: MKMapView, location: CLLocation, placeType: String, radius: Double) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = placeType
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response: MKLocalSearchResponse!, error: NSError!) in
            if error != nil {
                println("Error occured in search: \(error.localizedDescription)")
            } else if response.mapItems.count == 0 {
                println("No matches found")
            } else {
                for item in response.mapItems as! [MKMapItem] {
//                    println("Name = \(item.name)")
                    
                    var placeMark = item.placemark as MKPlacemark!
                    var address = placeMark.addressDictionary as NSDictionary!
                    var titleString: String!
                    var subtitleString: String!
                    var name: String!
                    var street: String!
                    var zip: String!
                    var city: String!
                    
                    let distance = Int(location.distanceFromLocation(placeMark.location))
                    
                    name = (address.objectForKey("Name") != nil ? address.objectForKey("Name") : "") as! String
                    street = (address.objectForKey("Street") != nil ? address.objectForKey("Street") : "") as! String
                    zip = (address.objectForKey("ZIP") != nil ? address.objectForKey("ZIP") : "") as! String
                    city = (address.objectForKey("City") != nil ? address.objectForKey("City") : "") as! String
                    titleString = "\(name) (\(distance)m)"
                    subtitleString = "\(street), \(city), \(zip)"
                    
                    var pin = CustomPointAnnotation()
                    pin.coordinate = item.placemark.coordinate
                    pin.title = titleString
                    pin.subtitle = subtitleString
                    pin.iconImage = UIImage(named: "cafe")
                    
                    pin.name = name
                    pin.url = item.url
                    pin.mapItem = item
                    
                    mapView.addAnnotation(pin)
                }
            }
        })
    }
    
}
