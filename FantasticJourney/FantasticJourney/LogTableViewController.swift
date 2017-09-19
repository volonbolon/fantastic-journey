//
//  LogTableViewController.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/12/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import UIKit
import CoreData

class LogTableViewCell:UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
}

class LogTableViewControllerDatasource:NSObject, UITableViewDataSource {
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!
    
    private var _context:NSManagedObjectContext?
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
    
    private var _dateFormatter:DateFormatter?
    var dateFormatter:DateFormatter {
        get {
            if self._dateFormatter == nil {
                let df = DateFormatter()
                df.dateStyle = .short
                df.timeStyle = .short
                self._dateFormatter = df
            }
            return self._dateFormatter!
        }
    }
    
    override init() {
        super.init()
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = Location.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "arrivalDate", ascending: true)
        fetchRequest.sortDescriptors = [sortByDate]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let s = sections[section]
            return s.numberOfObjects
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! LogTableViewCell
        
        let location = self.fetchedResultsController.object(at: indexPath) as! Location
        let lat = String(format:"%.5f", location.latitude)
        let lng = String(format:"%.5f", location.longitude)
        cell.locationLabel.text = "\(lat), \(lng)"
        let date = self.dateFormatter.string(from: location.arrivalDate! as Date)
        cell.timestampLabel.text = date
        
        return cell
    }
}

class LogTableViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.StoryboardsIdentifier.ShowDetailsFromList {
            if let ip = self.tableView.indexPathForSelectedRow {
                let tableViewDatasource = self.tableView.dataSource as! LogTableViewControllerDatasource
                let location = tableViewDatasource.fetchedResultsController.object(at: ip) as! Location
                let dvc = segue.destination as! LocationDetailsViewController
                dvc.location = location
            }
        }
    }
}
