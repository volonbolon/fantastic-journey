//
//  AppDelegate.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/12/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications
import UserNotificationsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var bgTask:UIBackgroundTaskIdentifier? = nil
    
    var window: UIWindow?
    let locationManager = IntrospectiveCoreLocationManager()
    var deferringLocation = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let nc = UNUserNotificationCenter.current()
        nc.delegate = self
        nc.requestAuthorization(options: [.sound, .alert]) { (granted:Bool, e:Error?) in
            if e != nil {
                print(e!)
            }
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FantasticJourney")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate:CLLocationManagerDelegate {
    var dateFormatter:DateFormatter {
        get {
            let df = DateFormatter()
            df.dateStyle = .short
            df.timeStyle = .short
            
            return df
        }
    }
    
    fileprivate func addLocation(coordinate:CLLocationCoordinate2D, arrivalDate:Date, departureDate:Date, origin:LocationOrigin) {
        let moc = self.persistentContainer.viewContext
        // bitrise test
        let location = NSEntityDescription.insertNewObject(forEntityName: Location.ManagedObjectName, into: moc) as! Location
        location.coordinate = coordinate
        location.origin = origin.rawValue
        location.arrivalDate = arrivalDate as NSDate
        location.departureDate = departureDate as NSDate
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("New Location Saved", comment: "New Location Saved")
        let df = self.dateFormatter
        
        let arrivalDate = df.string(from: location.arrivalDate! as Date)
        let departureDate = df.string(from: location.departureDate! as Date)
        
        content.body = "arrivalDate: \(arrivalDate), departureDate: \(departureDate), coordinate: \(location.coordinate) origin: \(location.origin)"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "LocationUpdate", content: content, trigger: trigger)
        let nc = UNUserNotificationCenter.current()
        
        self.bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            if let bgt = self.bgTask {
                UIApplication.shared.endBackgroundTask(bgt)
            }
            self.bgTask = nil
        })
        
        nc.add(request) { (e:Error?) in
            if let er = e {
                print(er)
            }
        }
        
        self.sendLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let l = locations.last!
        self.addLocation(coordinate: l.coordinate, arrivalDate: l.timestamp, departureDate: Date.distantFuture, origin: LocationOrigin.significantChange)
        if !self.deferringLocation {
            self.locationManager.allowDeferredLocationUpdates(untilTraveled: 300, timeout: 300)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if error == nil {
            print(error!)
        } else {
            self.deferringLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        self.addLocation(coordinate: visit.coordinate, arrivalDate: visit.arrivalDate, departureDate: visit.departureDate, origin: LocationOrigin.visit)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        print("\(notification.request.content.userInfo)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("\(response.notification.request.content.userInfo)")
    }
}

extension AppDelegate { // NSURLSession
    func sendLocation(location:Location) {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Request Duplicate (POST https://fathomless-beyond-71849.herokuapp.com/locations)
         */
        
        guard let URL = URL(string: "https://fathomless-beyond-71849.herokuapp.com/locations") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        // Headers
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // JSON Body
        
        let bodyObject: [String : Any] = [
            "origin": location.locationOrigin.description,
            "latitude":location.latitude,
            "longitude":location.longitude,
            "departure": Int(location.departureDate!.timeIntervalSince1970),
            "arrival": Int(location.arrivalDate!.timeIntervalSince1970), //1506342247
            "rating":location.locationRating.description
        ]
        
        print(bodyObject)
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let success = error == nil
            
            DispatchQueue.main.async {
                let moc = location.managedObjectContext
                
                location.successfullyPosted = success
                
                do {
                    try moc!.save()
                } catch {
                    print(error)
                }
                
                if let bgt = self.bgTask {
                    UIApplication.shared.endBackgroundTask(bgt)
                    self.bgTask = nil
                }
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}



