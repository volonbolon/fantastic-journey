//
//  Location+CoreDataClass.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/14/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

enum LocationOrigin:Int {
    case visit
    case significantChange
}

@objc(Location)
public class Location: NSManagedObject {
    static let ManagedObjectName:String = "Location"
    
    var coordinate:CLLocationCoordinate2D {
        get {
            let lc = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            return lc
        }
        
        set {
            self.latitude = newValue.latitude
            self.longitude = newValue.longitude
        }
    }
}
