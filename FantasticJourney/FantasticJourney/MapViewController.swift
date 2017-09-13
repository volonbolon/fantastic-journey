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

extension Double {
    
    /// Generates a random `Double` within `0.0...1.0`
    public static func random() -> Double {
        return random(interval: 0.0...1.0)
    }
    
    /// Generates a random `Double` inside of the closed interval.
    public static func random(interval: ClosedRange<Double>) -> Double {
        return interval.lowerBound + (interval.upperBound - interval.lowerBound) * (Double(arc4random()) / Double(UInt32.max))
    }
}

extension MKCoordinateRegion {
    private func getMinAndMax(_ pivot:CLLocationDegrees, span:CLLocationDegrees) -> (CLLocationDegrees, CLLocationDegrees) {
        let lr = span / 2.0
        let ld1 = pivot - lr
        let ld2 = pivot + lr
        
        let mxl = CLLocationDegrees(max(ld1, ld2))
        let mml = CLLocationDegrees(min(ld1, ld2))
        
        return (mml, mxl)
    }
    
    func randomCoordinate() -> CLLocationCoordinate2D {
        let ltmm = self.getMinAndMax(self.center.latitude, span: self.span.latitudeDelta)
        let lnmm = self.getMinAndMax(self.center.longitude, span: self.span.longitudeDelta)
        
        let latRange:ClosedRange<Double> = ClosedRange(uncheckedBounds: (lower: ltmm.0, upper: ltmm.1))
        let lngRange:ClosedRange<Double> = ClosedRange(uncheckedBounds: (lower: lnmm.0, upper: lnmm.1))
        
        let lat = Double.random(interval: latRange)
        let lng = Double.random(interval: lngRange)
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController:MKMapViewDelegate {
    private static var reuseIdentifer:String {
        get {
            return "mapAnnotation"
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        /* 
         {
         super.viewDidLoad()
         
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         let location = NSEntityDescription.insertNewObject(forEntityName: Location.ManagedObjectName, into: context) as! Location
         location.latitude = -73.45
         location.longitude = 34.56
         location.timestamp = Date() as NSDate
         location.origin = 1
         
         do {
         try context.save()
         } catch {
         print(error)
         }
         }
 */
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let mapRegion = mapView.region
        var annotations:[MKPointAnnotation] = []
        for _ in 0..<15 {
            let c = mapRegion.randomCoordinate()
            let location = NSEntityDescription.insertNewObject(forEntityName: Location.ManagedObjectName, into: context) as! Location
            location.latitude = c.latitude
            location.longitude = c.longitude
            location.timestamp = Date() as NSDate
            location.origin = Int16(arc4random_uniform(3)) + 1
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = c
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        
        do {
            try context.save()
        } catch {
            print(error)
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
        annotationView.canShowCallout = true
        return annotationView
    }
}
