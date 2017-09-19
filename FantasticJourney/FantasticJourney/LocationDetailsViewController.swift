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
        
        self.title = "\(self.location.locationOrigin) || "

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
