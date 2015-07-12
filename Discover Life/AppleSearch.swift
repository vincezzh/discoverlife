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
                    println("Name = \(item.name)")
                    
                    var placeMark = item.placemark as MKPlacemark!
                    var address = placeMark.addressDictionary as NSDictionary!
                    var titleString: String!
                    var subtitleString: String!
                    var name: String!
                    var Thoroughfare: String!
                    var State: String!
                    var City: String!
                    var Country: String!
                    
                    var emptyString: String! = " "
                    
                    name = (address.objectForKey("name") != nil ? address.objectForKey("name") : emptyString) as! String
                    Thoroughfare = (address.objectForKey("Thoroughfare") != nil ? address.objectForKey("Thoroughfare") : emptyString) as! String
                    State = (address.objectForKey("State") != nil ? address.objectForKey("State") : emptyString) as! String
                    City = (address.objectForKey("City") != nil ? address.objectForKey("City") : emptyString) as! String
                    Country = (address.objectForKey("Country") != nil ? address.objectForKey("Country") : emptyString) as! String
                    
                    titleString = String(format: "%@ %@", name, Thoroughfare)
                    subtitleString = String(format: "%@ %@ %@", State, City, Country)
                    
                    var pin = CustomPointAnnotation()
                    pin.coordinate = item.placemark.coordinate
                    pin.title = item.name
                    pin.subtitle = titleString
                    pin.iconImage = UIImage(named: "cafe")
                    mapView.addAnnotation(pin)
                }
            }
        })
    }
    
}
