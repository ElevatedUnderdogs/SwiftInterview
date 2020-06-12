//
//  CLLocationManager.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import CoreLocation

public extension CLLocationManager {
    
    func setFrequency(high: Bool) {
        if high {
            desiredAccuracy = kCLLocationAccuracyBest
            distanceFilter = kCLDistanceFilterNone
        } else {
            desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            distanceFilter = 30
        }
    }
    
    static var alwaysAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    
    func setFrequency(foreground: Bool) {
        if foreground {
            desiredAccuracy = 25
            distanceFilter = 25
        } else {
            desiredAccuracy = 150
            distanceFilter = 100
        }
    }
}
