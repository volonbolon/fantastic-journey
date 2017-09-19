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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContextChanges), name: .NSManagedObjectContextObjectsDidChange, object: self.context)
        
        let locationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Location.ManagedObjectName)
        
        var locations:[LocationAnnotation] = []
        do {
            let fetch = try self.context.fetch(locationFetch) as! [Location]
            for l in fetch {
                let av = LocationAnnotation(location: l)
                locations.append(av)
            }
            self.mapView.addAnnotations(locations)
        } catch {
            print(error)
        }
    }

    @IBAction func export(_ sender: Any) {
        let s = self.exportString()
        self.saveAndExport(exportString: s)
    }
}

extension MapViewController { // MARK:- Export
    var exportDateFormatter:DateFormatter {
        get {
            let df = DateFormatter()
            df.dateFormat = "dd.MM.yy hh:MM a"
            return df
        }
    }
    
    func saveAndExport(exportString: String) {
        let exportFilePath = NSTemporaryDirectory() + "locations.csv"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
        }
        
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(csvData!)
            
            fileHandle!.closeFile()
            
            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [
                UIActivityType.assignToContact,
                UIActivityType.saveToCameraRoll,
                UIActivityType.postToFlickr,
                UIActivityType.postToVimeo,
                UIActivityType.postToTencentWeibo
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func exportString() -> String {
        let locationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Location.ManagedObjectName)

        var exportString = "Origin, Coordinate, Arrival Date, Departure Date\n"

        let df = self.exportDateFormatter
        do {
            let fetch = try self.context.fetch(locationFetch) as! [Location]
            for l in fetch {
                let arrivalDate = df.string(from: l.arrivalDate! as Date)
                let departureDate = df.string(from: l.departureDate! as Date)
                let coordinate = "\(l.latitude) \(l.longitude)"
                let s = "\(l.locationOrigin), \(coordinate), \(arrivalDate), \(departureDate)"
                exportString += s
            }
        } catch {
            print(error)
        }

        return exportString
    }
}

extension MapViewController { // MARK:- Helpers
    func handleContextChanges(notification:Notification) {
        if let inserted = notification.userInfo?[NSInsertedObjectsKey] as? Set<Location>, inserted.count > 0 {
            for l in inserted {
                let av = LocationAnnotation(location: l)
                self.mapView.addAnnotation(av)
            }
        }
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
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        if annotation is LocationAnnotation {
            let origin = (annotation as! LocationAnnotation).origin
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

extension CLLocationCoordinate2D: CustomStringConvertible {
    public var description:String {
        get {
            return "\(self.latitude);\(self.longitude)"
        }
    }
}
