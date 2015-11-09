//
//  ViewController.swift
//  HelloBeacon
//
//  Created by Hino Banzon on 11/7/15.
//  Copyright © 2015 Hino Banzon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    let beaconManager = ESTBeaconManager()
    
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "Entire House"
    )
    
    @IBOutlet weak var nearestBeaconLabel: UILabel!
    
    // MARK: Sample Data Structure
    let placesByBeacons = [
        "31194:58554": [
            "Heavenly Sandwiches": 50,
            "Green & Green Salads": 150,
            "Mini Panini": 325
        ],
        "63029:44225": [
            "Heavenly Sandwiches": 250,
            "Green & Green Salads": 100,
            "Mini Panini": 20
        ],
        "52066:51215": [
            "Heavenly Sandwiches": 350,
            "Green & Green Salads": 500,
            "Mini Panini": 170
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
        let nearestBeacon = beacons[0] as CLBeacon
        let places = placesNearBeacon(nearestBeacon)
        self.nearestBeaconLabel.text = places[0]
        print(places)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

