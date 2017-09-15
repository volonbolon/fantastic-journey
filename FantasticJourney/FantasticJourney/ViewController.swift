//
//  ViewController.swift
//  FantasticJourney
//
//  Created by Ariel Rodriguez on 9/12/17.
//  Copyright © 2017 Sp0n. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleAction(_ sender: UIButton) {
        var title:String!
        if self.locationManager.updating {
            self.pickerView.isUserInteractionEnabled = true
            title = NSLocalizedString("Start", comment: "Start")
            self.stopServices()
        } else {
            self.pickerView.isUserInteractionEnabled = false
            title = NSLocalizedString("Stop", comment: "Stop")
            self.startServices()
        }
        sender.setTitle(title, for: UIControlState.normal)
    }
}

extension ViewController { // MARK:- Helpers
    var locationManager:IntrospectiveCoreLocationManager {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let locationManager = appDelegate.locationManager
            return locationManager
        }
    }
    
    func stopServices() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        switch row {
        case 0:
            self.locationManager.stopMonitoringVisits()
        case 1:
            self.locationManager.stopUpdatingLocation()
        default:
            self.locationManager.stopUpdatingLocation()
            self.locationManager.stopMonitoringVisits()
        }
    }
    
    func startServices() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        switch row {
        case 0:
            self.locationManager.startMonitoringVisits()
        case 1:
            self.locationManager.startMonitoringSignificantLocationChanges()
        default:
            self.locationManager.startMonitoringVisits()
            self.locationManager.startMonitoringSignificantLocationChanges()
        }
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titleForRow:String!
        switch row {
        case 0:
            titleForRow = NSLocalizedString("Visit", comment: "Visit")
        case 1:
            titleForRow = NSLocalizedString("Significant Changes", comment: "Significant Changes")
        default:
            titleForRow = NSLocalizedString("Both", comment: "Both")
        }
        return titleForRow
    }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
}

