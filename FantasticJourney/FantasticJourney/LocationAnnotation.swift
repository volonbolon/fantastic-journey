//
//  LocationAnnotation.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/19/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationAnnotation:NSObject, MKAnnotation {
    let location:Location
    
    var origin:LocationOrigin {
        get {
            return self.location.locationOrigin
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return self.location.coordinate
        }
    }
    
    var title: String? {
        get {
            return self.location.title
        }
    }
    
    var subtitle: String?
    
    init(location:Location) {
        self.location = location
    }
}
