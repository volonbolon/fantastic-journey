//
//  IntrospectiveCoreLocationManager.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/15/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import UIKit
import CoreLocation

class IntrospectiveCoreLocationManager: CLLocationManager {
    var updating = false
    
    override func startMonitoringVisits() {
        self.updating = true
        super.startMonitoringVisits()
    }
    
    override func stopMonitoringVisits() {
        self.updating = false
        super.stopMonitoringVisits()
    }
    
    override func startUpdatingLocation() {
        self.updating = true
        super.startUpdatingLocation()
    }
    
    override func stopUpdatingLocation() {
        self.updating = false
        super.stopUpdatingLocation()
    }
}
