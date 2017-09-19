//
//  LocationDetailsViewController.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/19/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailsViewController: UIViewController {
    var location:Location!
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = location.title
        
        let av = LocationAnnotation(location:self.location)
        self.mapView.addAnnotation(av)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: self.location.coordinate, span: span)
        self.mapView.setRegion(region, animated: false)
        
        self.segmentedControl.selectedSegmentIndex = Int(location.rating)
    }

    @IBAction func ratingChanged(_ sender: Any) {
        let lr = LocationRating(rawValue: Int16(self.segmentedControl.selectedSegmentIndex))!
        self.location.locationRating = lr
        
        do {
            try self.location.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
