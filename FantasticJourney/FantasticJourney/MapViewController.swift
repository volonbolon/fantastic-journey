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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Location.ManagedObjectName)
        
        do {
            let fetch = try self.context.fetch(locationFetch) as! [Location]
            for l in fetch {
                print(l)
            }
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
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//        let mapRegion = mapView.region
//        var annotations:[MKPointAnnotation] = []
//        for _ in 0..<215 {
//            let c = mapRegion.randomCoordinate()
//            let location = NSEntityDescription.insertNewObject(forEntityName: Location.ManagedObjectName, into: context) as! Location
//            location.latitude = c.latitude
//            location.longitude = c.longitude
//            location.timestamp = Date() as NSDate
//            location.origin = Int16(arc4random_uniform(2)) + 1
//            
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = c
//            annotations.append(annotation)
//        }
//        mapView.addAnnotations(annotations)
//        
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = MapViewController.reuseIdentifer
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        return annotationView
    }
}
