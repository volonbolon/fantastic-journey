//
//  Location+CoreDataProperties.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/12/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var timestamp: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var origin: Int16

}
