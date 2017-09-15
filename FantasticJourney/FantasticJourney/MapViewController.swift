//
//  MapViewController.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/12/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class LocationAnnotation:NSObject, MKAnnotation {
    var origin:LocationOrigin!
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate:CLLocationCoordinate2D, origin:LocationOrigin) {
        self.coordinate = coordinate
        self.origin = origin
    }
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var _context:NSManagedObjectContext?
    var context:NSManagedObjectContext {
        get {
            if self._context == nil {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                self._context = context
            }
            return self._context!
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let locationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Location.ManagedObjectName)
        
        var locations:[LocationAnnotation] = []
        do {
            let fetch = try self.context.fetch(locationFetch) as! [Location]
            for l in fetch {
                let av = LocationAnnotation(coordinate: l.coordinate, origin: l.locationOrigin)
                locations.append(av)
            }
            self.mapView.addAnnotations(locations)
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MapViewController:MKMapViewDelegate {
    private static var reuseIdentifer:String {
        get {
            return "mapAnnotation"
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = MapViewController.reuseIdentifer
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        annotationView.animatesDrop = true
        
        if annotation is LocationAnnotation {
            let origin = (annotation as! LocationAnnotation).origin!
            switch origin {
            case .visit:
                annotationView.pinTintColor = UIColor.red
            case .significantChange:
                annotationView.pinTintColor = UIColor.blue
            }
        }
        
        annotationView.canShowCallout = true
        return annotationView
    }
}
