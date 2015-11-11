//
//  ViewController.swift
//  HelloBeacon
//
//  Created by Hino Banzon on 11/7/15.
//  Copyright © 2015 Hino Banzon. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, ESTBeaconManagerDelegate {
    
    let beaconManager = ESTBeaconManager()
    
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "Hino Beacons"
    )
    
    var places : [String] = ["No Nearby Beacons"]

    // MARK: Sample Data Structure
    let placesByBeacons = [
        "31194:58554": [
            "Ice Beacon": 50,
            "Kitchen": 150,
            "Breakfast Bar": 325
        ],
        "63029:44225": [
            "Mint Beacon": 250,
            "Couch": 100,
            "Broken TV": 20,
            "Dining Table": 10
        ],
        "52066:51215": [
            "Blueberry Beacon": 350,
            "Hino's Desk": 500,
            "Home Plate": 170
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeaconsInRegion(beaconRegion)
    }
    
    //
    // get a list of places near the specified beacon
    //
    func placesNearBeacon(beacon: CLBeacon) -> [String] {
        let beaconKey = "\(beacon.major):\(beacon.minor)"
        if let places = self.placesByBeacons[beaconKey] {
            let sortedPlaces = Array(places).sort {$0.1 < $1.1}.map {$0.0}
            return sortedPlaces
        }
        return []
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        if beacons.count == 0 {
            self.places = ["No Nearby Beacons"]
        } else {
            self.places = []
            for beacon in beacons {
                self.places.appendContentsOf(placesNearBeacon(beacon))
            }
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //
    // called on UI load to fetch the number of cells to populate
    //
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count;
    }
    
    //
    // called to load updated data to the table view
    //
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")!
        var cellText = ""
        if self.places.count-1 >= indexPath.row {
            cellText = self.places[indexPath.row]
        }
        cell.textLabel?.text = cellText
        return cell
    }

}

