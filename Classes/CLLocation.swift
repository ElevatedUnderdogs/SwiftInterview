//
//  CLLocation.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//

import Foundation
import CoreLocation

public typealias StringAction = (String) -> Void

public extension CLLocation {
    
    convenience init(_ coord: CLLocationCoordinate2D) {
        self.init(latitude: coord.latitude, longitude: coord.longitude)
    }
    
    func address(_ action: @escaping StringAction) {
        let geoCoder = CLGeocoder()
        var address = ""
        geoCoder.reverseGeocodeLocation(self) {
            placemarks, error in
            guard let placeMark = placemarks?[0] else { return }
            if let locationName = placeMark.name  {
                address = locationName
            }
            if let city = placeMark.locality {
                address.append(" \(city)")
            }
            action(address)
        }
    }
}
