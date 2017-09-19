//
//  Location+CoreDataProperties.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/19/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var arrivalDate: NSDate?
    @NSManaged public var departureDate: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var origin: Int16
    @NSManaged public var rating: Int16

}
