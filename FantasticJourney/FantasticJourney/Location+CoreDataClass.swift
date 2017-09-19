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

enum LocationOrigin:Int16 {
    case visit = 1
    case significantChange = 2
}

extension LocationOrigin:CustomStringConvertible {
    var description: String {
        get {
            var description:String!
            switch self {
            case .visit:
                description = "CLVisit"
            default:
                description = "Significant Change"
            }
            return description
        }
    }
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
    
    var locationOrigin:LocationOrigin {
        get {
            return LocationOrigin(rawValue: self.origin)!
        }
    }
    
    var title:String {
        get {
            let df = DateFormatter()
            df.dateStyle = .short
            df.timeStyle = .short
            
            let arrivalDateString = df.string(from: self.arrivalDate! as Date)
            var title = "\(self.locationOrigin) || \(arrivalDateString)"
            
            if let dd = self.departureDate, (dd as Date) != Date.distantFuture {
                let departureDateString = df.string(from:dd as Date)
                title += " \(departureDateString)"
            }
            return title
        }
    }
}
